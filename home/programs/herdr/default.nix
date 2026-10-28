{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  # herdr — terminal workspace manager for AI coding agents. The desktop runs
  # the server; every other host attaches to it with `herdr-desk` (below),
  # and `herdr --remote` needs a client of the SAME version on both ends.
  herdr = pkgs.stdenv.mkDerivation rec {
    pname = "herdr";
    version = "0.9.5";
    src = let
      assets = {
        aarch64-linux = {
          suffix = "linux-aarch64";
          hash = "sha256-F9dTby2lCFlSNoDvJ53/ysjkojX05G/o2mwuxEFBiXw=";
        };
        x86_64-linux = {
          suffix = "linux-x86_64";
          hash = "sha256-FNnovItKngEY13wyJm921GHwm0A0LrI3UpYL2J9Zkp0=";
        };
      };
      inherit (pkgs.stdenv.hostPlatform) system;
      asset = assets.${system} or (throw "herdr: no upstream binary for ${system}");
    in
      pkgs.fetchurl {
        url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-${asset.suffix}";
        inherit (asset) hash;
      };
    dontUnpack = true;
    dontStrip = true;
    installPhase = ''
      install -Dm755 $src $out/bin/herdr
    '';
  };

  # Claude runs on the desktop (inside ralph containers), so its "open this
  # URL", "copy this" and voice capture all happen on the wrong machine when
  # you are attached from here. The ssh session for `herdr-desk` carries two
  # reverse forwards back to this device:
  #
  #   desktop 127.0.0.1:<bridgePort> -> bridgeSock  (open / copy requests)
  #   desktop 127.0.0.1:47102        -> local PulseAudio socket (microphone)
  #
  # TCP on the desktop end, not a unix socket: plain ssh to the desktop lands
  # on Tailscale SSH, and TCP forwards work there as well as with OpenSSH.
  # Each device forwards the bridge to a port of its own: with one shared
  # port, the first device to attach (a phone left attached, say) held it,
  # and every other device's copies landed on the desktop clipboard instead.
  # herdr-bridge (./bridge.sh) is the desktop end: it tries every port until
  # a listener acts. The microphone port is still shared, so only one device
  # owns it at a time; a second one still attaches, just without it. The
  # container relays live below and in hosts/desktop, the container shim in
  # ralph-code.
  bridgePorts = {
    desktop = 47101;
    work-laptop = 47111;
    laptop_perso = 47121;
    phone = 47131;
  };
  bridgePort = bridgePorts.${osConfig.machineType};
  pulsePort = 47102;
  bridgeSock = "${config.home.homeDirectory}/.cache/herdr-bridge.sock";

  # Listens on bridgeSock and acts on what the desktop sends: a line naming
  # the op, then the payload. Replies "ok" when it handled the request and
  # "no" when this device can't (no clipboard tool, a host path to open), so
  # the desktop falls back (./bridge.sh). termux-open-url comes first: it
  # only exists on the phone (hosts/phone/nix-on-droid.nix), where it is the
  # direct way into Android.
  bridgeListen = pkgs.writers.writePython3Bin "herdr-bridge-listen" {flakeIgnore = ["E501"];} ''
    import glob
    import os
    import shutil
    import socket
    import subprocess
    import sys

    SOCK = sys.argv[1]


    def env_with_wayland():
        env = dict(os.environ)
        if not env.get("WAYLAND_DISPLAY"):
            rt = env.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
            for s in sorted(glob.glob(f"{rt}/wayland-[0-9]")):
                env["WAYLAND_DISPLAY"] = os.path.basename(s)
                break
        return env


    def copy(data):
        env = env_with_wayland()
        tools = [
            (["wl-copy"], "WAYLAND_DISPLAY"),
            (["pbcopy"], None),
            (["xclip", "-selection", "clipboard"], "DISPLAY"),
            (["termux-clipboard-set"], None),
        ]
        for cmd, needs in tools:
            if shutil.which(cmd[0]) and (needs is None or env.get(needs)):
                subprocess.run(cmd, input=data, env=env, timeout=5)
                return True
        return False


    def open_url(data):
        url = data.decode(errors="replace").strip()
        # A path names a file on the desktop, which doesn't exist here.
        if "://" not in url:
            return False
        for cmd in ("termux-open-url", "xdg-open", "open"):
            if shutil.which(cmd):
                subprocess.Popen(
                    [cmd, url], env=env_with_wayland(), start_new_session=True,
                    stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                )
                return True
        return False


    def serve():
        # Another listener already answering: leave it be.
        probe = socket.socket(socket.AF_UNIX)
        try:
            probe.connect(SOCK)
            return
        except OSError:
            pass
        finally:
            probe.close()
        try:
            os.unlink(SOCK)
        except FileNotFoundError:
            pass
        os.makedirs(os.path.dirname(SOCK), exist_ok=True)
        srv = socket.socket(socket.AF_UNIX)
        srv.bind(SOCK)
        os.chmod(SOCK, 0o600)
        srv.listen(4)
        while True:
            conn, _ = srv.accept()
            with conn:
                conn.settimeout(5)
                buf = b""
                try:
                    while chunk := conn.recv(65536):
                        buf += chunk
                    op, _, payload = buf.partition(b"\n")
                    ok = {"copy": copy, "open": open_url}.get(op.decode(), lambda _: False)(payload)
                    conn.sendall(b"ok\n" if ok else b"no\n")
                except Exception as e:  # one bad request must not kill the bridge
                    print(f"herdr-bridge-listen: {e}", file=sys.stderr)


    serve()
  '';

  herdrDesk = pkgs.writeShellScriptBin "herdr-desk" ''
    # Attach to the herdr session on the desktop, with the bridge listening so
    # Claude there can open URLs, copy and record audio on this device.
    ${bridgeListen}/bin/herdr-bridge-listen ${bridgeSock} &
    listener=$!
    trap 'kill $listener 2>/dev/null' EXIT
    ${herdr}/bin/herdr --remote herdr-desktop --remote-keybindings server "$@"
  '';

  # A server the client spawns lands in the terminal's cgroup scope, and so
  # does every pane under it, all sharing that scope's task limit with the
  # terminal. So start the server in a scope of its own, with a limit of its
  # own, before the client attaches. Falls through to plain herdr where there is no systemd
  # user manager (Termux).
  #
  # The scope keeps a task limit. On 15 Oct agents hit the default (57480)
  # and the limit was lifted; the cause was a fork bomb (autobin resolving
  # its own `mkdir` through itself), and with no limit the next one on 16 Oct
  # filled RAM and swap and locked up the machine. 16384 tasks stop a fork
  # bomb at a few GiB and leave room for every agent's normal load.
  herdrLauncher = pkgs.writeShellScriptBin "herdr" ''
    real=${herdr}/bin/herdr
    session=() unit=herdr-server
    if [ "''${1-}" = --session ] && [ -n "''${2-}" ]; then
      session=(--session "$2")
      unit="herdr-server-$(systemd-escape "$2" 2>/dev/null)"
      shift 2
    fi

    if command -v systemd-run >/dev/null && [ -S "''${XDG_RUNTIME_DIR-}/bus" ]; then
      if [ "$*" = server ]; then
        exec systemd-run --user --scope --quiet --collect \
          --unit="$unit" -p TasksMax=16384 "$real" "''${session[@]}" server
      fi
      # setsid: in the client's process group, the server would take the
      # terminal's hangup when the window closes.
      if [ "$#" -eq 0 ] && ! "$real" "''${session[@]}" status server | grep -q 'status: running'; then
        ${pkgs.util-linux}/bin/setsid -f "$0" "''${session[@]}" server </dev/null >/dev/null 2>&1
        for _ in $(seq 40); do
          "$real" "''${session[@]}" status server | grep -q 'status: running' && break
          sleep 0.25
        done
      fi
    fi
    exec "$real" "''${session[@]}" "$@"
  '';

  # The commands config.toml binds to keys. herdr runs them with the server's
  # environment, and a server that `herdr --remote` started has only a bare
  # ssh-login PATH, so each script carries its own tools.
  script = name: runtimeInputs:
    pkgs.writeShellApplication {
      name = "herdr-${name}";
      inherit runtimeInputs;
      text = builtins.readFile ./${name}.sh;
    };
  herdrBridge = pkgs.writeShellApplication {
    name = "herdr-bridge";
    runtimeInputs = with pkgs; [python3 wl-clipboard util-linux coreutils];
    runtimeEnv.HERDR_BRIDGE_PORTS = toString (builtins.attrValues bridgePorts);
    text = builtins.readFile ./bridge.sh;
  };
  herdrPick = script "pick" (with pkgs; [herdr herdrBridge jq fzf gnugrep gnused gawk coreutils]);
  herdrBreakPane = script "break-pane" (with pkgs; [herdr jq]);
  herdrSubjectPoller = script "subject-poller" (with pkgs; [herdr jq coreutils]);

  # Programs in a pane run here, in the desktop's Wayland session, so their
  # "open this URL" (gcloud, gh, Claude Code) and "copy this" (nvim, zsh)
  # land on the desktop even when you are attached from the phone. herdr
  # passes neither back. Put ahead of the real tools on a pane's PATH (zsh
  # below), these route both through herdr-bridge to the device you are on.
  # herdr-bridge sets HERDR_BRIDGE_ACTIVE for its own local fallback, which
  # must reach the real tools.
  paneTools = pkgs.symlinkJoin {
    name = "herdr-pane-tools";
    paths = [
      (pkgs.writeShellScriptBin "xdg-open" ''
        # BROWSER points here too, and the real xdg-open falls back to it.
        unset BROWSER
        # Only URLs: a path names a file here, which only the desktop can open.
        if [ -z "''${HERDR_BRIDGE_ACTIVE-}" ] && [ $# -eq 1 ] && [[ $1 == *://* ]]; then
          exec ${herdrBridge}/bin/herdr-bridge open "$1"
        fi
        exec ${pkgs.xdg-utils}/bin/xdg-open "$@"
      '')
      (pkgs.writeShellScriptBin "wl-copy" ''
        # Only a plain text copy. Anything else (--primary, --clear, an image
        # --type) goes to the real wl-copy.
        real=${pkgs.wl-clipboard}/bin/wl-copy
        [ -n "''${HERDR_BRIDGE_ACTIVE-}" ] && exec "$real" "$@"
        args=("$@")
        while [ $# -gt 0 ]; do
          case $1 in
            -n | --trim-newline | -f | --foreground | --type=text/*) shift ;;
            -t | --type) [[ ''${2-} == text/* ]] || exec "$real" "''${args[@]}"; shift 2 ;;
            --) shift; break ;;
            -*) exec "$real" "''${args[@]}" ;;
            *) break ;;
          esac
        done
        if [ $# -gt 0 ]; then
          exec ${herdrBridge}/bin/herdr-bridge copy "$*"
        fi
        exec ${herdrBridge}/bin/herdr-bridge copy
      '')
    ];
  };
in {
  home.packages = [herdrLauncher herdrDesk herdrBridge herdrPick herdrBreakPane];

  # HERDR_ENV is herdr's mark on every pane and popup it starts. zshenv, so
  # `zsh -c` from an agent gets the tools as well.
  programs.zsh.envExtra = lib.mkIf (osConfig.machineType == "desktop") ''
    if [[ -n "''${HERDR_ENV-}" ]]; then
      case ":$PATH:" in
        *:${paneTools}/bin:*) ;;
        *) export PATH="${paneTools}/bin:$PATH" ;;
      esac
      export BROWSER=${paneTools}/bin/xdg-open
    fi
  '';

  # Headlines each agent row with its session subject (./subject-poller.sh).
  # It waits while no server runs, so one service covers every server this
  # host starts, wherever it was started from.
  # ralph containers sit on their own docker network, where the desktop's
  # loopback is out of reach, so relay a unix socket that ralph.sh
  # bind-mounts into every container onto the device ports.
  systemd.user.services.herdr-remote-bridge = lib.mkIf (osConfig.machineType == "desktop") {
    Unit.Description = "herdr remote bridge relay";
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p -m 700 %t/herdr-remote";
      ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:%t/herdr-remote/bridge.sock,fork,unlink-early,mode=600 EXEC:'${herdrBridge}/bin/herdr-bridge forward'";
      Restart = "always";
    };
    Install.WantedBy = ["default.target"];
  };

  systemd.user.services.herdr-subject-poller = {
    Unit.Description = "herdr agent subject poller";
    Service = {
      ExecStart = "${herdrSubjectPoller}/bin/herdr-subject-poller";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };

  # Link the checkout's config.toml rather than a store copy: herdr writes back
  # to it (`onboarding = false` on first run, `herdr config reset-keys`), and
  # those writes should land in the repo where git can show them.
  # force: the pre-dotfiles symlink pointed at the ralph-code checkout, so
  # Home Manager finds an unmanaged file here and refuses to replace it.
  xdg.configFile."herdr/config.toml" = {
    force = true;
    source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.hostDir}../../home/programs/herdr/config.toml";
  };

  programs.ssh.settings."herdr-desktop" = {
    # The Tailscale IP, not the MagicDNS name: on Android the system Tailscale
    # app owns the tunnel, and Termux's resolver never sees MagicDNS, so
    # `dev-1` fails to resolve there. The IP is stable and works on every host.
    HostName = "100.97.145.107";
    User = "rob";
    RemoteForward = [
      "127.0.0.1:${toString bridgePort} ${bridgeSock}"
      "127.0.0.1:${toString pulsePort} /run/user/%i/pulse/native"
    ];
    # The forwards are extras: attach anyway when they can't be set up.
    ExitOnForwardFailure = false;
  };
}
