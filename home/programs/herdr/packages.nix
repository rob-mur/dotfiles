# The herdr binary and the herdr-* commands, kept apart from the Home Manager
# module (./default.nix) so the flake check (./check-pick-open.nix) builds and
# tests the same derivations that get installed.
{pkgs}: rec {
  # herdr — terminal workspace manager for AI coding agents. The desktop runs
  # the server; every other host attaches to it with `herdr-desk` (default.nix),
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

  # The desktop port each device reverse-forwards its bridge listener to
  # (default.nix explains why each device has a port of its own).
  bridgePorts = {
    desktop = 47101;
    work-laptop = 47111;
    laptop_perso = 47121;
    phone = 47131;
  };

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
}
