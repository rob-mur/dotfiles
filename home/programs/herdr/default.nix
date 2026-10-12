{
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
    version = "0.7.4";
    src = let
      assets = {
        aarch64-linux = {
          suffix = "linux-aarch64";
          hash = "sha256-VE4AAt5CgG0atkzN7zp+dBTyRxewtrAivJ5X0u79JqI=";
        };
        x86_64-linux = {
          suffix = "linux-x86_64";
          hash = "sha256-vA/ALUulAPnKwjU6Q+Z/4DZ4Xsym61U3jgUPrDwQMFk=";
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
  #   desktop 127.0.0.1:47101 -> bridgeSock  (open / copy requests)
  #   desktop 127.0.0.1:47102 -> local PulseAudio socket (microphone)
  #
  # TCP on the desktop end, not a unix socket: plain ssh to the desktop lands
  # on Tailscale SSH, and TCP forwards work there as well as with OpenSSH. The desktop side
  # (relays into the containers) lives in hosts/desktop, and the container
  # shim in ralph-code. The ports are fixed, so only one attached device owns
  # the bridge at a time; a second one still attaches, just without the
  # forwards. herdr-bridge (./bridge.sh) is the desktop end that talks to the
  # listener.
  bridgePort = 47101;
  pulsePort = 47102;
  bridgeSock = "${config.home.homeDirectory}/.cache/herdr-bridge.sock";

  # Listens on bridgeSock and acts on what the desktop sends: a line naming
  # the op, then the payload. Replies "ok" when it handled the request and
  # "no" when this device can't (no clipboard tool, a host path to open), so
  # the desktop falls back to doing it itself.
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
        for cmd in ("xdg-open", "open", "termux-open-url"):
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

  # The commands config.toml binds to keys. herdr runs them with the server's
  # environment, and a server that `herdr --remote` started has only a bare
  # ssh-login PATH, so each script carries its own tools.
  script = name: runtimeInputs:
    pkgs.writeShellApplication {
      name = "herdr-${name}";
      inherit runtimeInputs;
      text = builtins.readFile ./${name}.sh;
    };
  herdrBridge = script "bridge" (with pkgs; [python3 wl-clipboard util-linux coreutils]);
  herdrPick = script "pick" (with pkgs; [herdr herdrBridge jq fzf gnugrep gnused gawk coreutils]);
  herdrBreakPane = script "break-pane" (with pkgs; [herdr jq]);
in {
  home.packages = [herdr herdrDesk herdrBridge herdrPick herdrBreakPane];

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
