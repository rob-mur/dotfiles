{pkgs, ...}: let
  # firstmate's toolchain. Its bootstrap would otherwise curl | sh and
  # npm install -g these; pin them here instead.
  kunchenguidRelease = {
    pname,
    version,
    hash,
  }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl {
        url = "https://github.com/kunchenguid/${pname}/releases/download/v${version}/${pname}-v${version}-linux-amd64.tar.gz";
        inherit hash;
      };
      sourceRoot = ".";
      nativeBuildInputs = [pkgs.autoPatchelfHook];
      installPhase = "install -Dm755 ${pname} $out/bin/${pname}";
    };

  treehouse = kunchenguidRelease {
    pname = "treehouse";
    version = "3.1.4";
    hash = "sha256:a169277ffdc5f48b51a4b53ce6c2e46fe3c222a5017c67f72bf9260a9b382ae2";
  };

  no-mistakes = kunchenguidRelease {
    pname = "no-mistakes";
    version = "1.84.0";
    hash = "sha256:b0fb8a9df412c5fa1fb92a3584ffa1d4d5b4d6e0d1738efa2f8b88320f8bf1c2";
  };

  # gh-axi, tasks-axi, quota-axi and chrome-devtools-axi, from package-lock.json.
  axiModules = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = pkgs.nodejs;
  };
  axiTools = pkgs.runCommand "firstmate-axi-tools" {} ''
    mkdir -p $out/bin
    for bin in ${axiModules}/node_modules/.bin/*; do
      ln -s "$(readlink -f "$bin")" "$out/bin/$(basename "$bin")"
    done
  '';

  toolchain = [treehouse no-mistakes pkgs.tea axiTools];

  # herdr and claude come from their own modules, through the user's PATH.
  firstmate = pkgs.writeShellApplication {
    name = "firstmate";
    runtimeInputs = toolchain ++ (with pkgs; [git jq coreutils gawk gnugrep]);
    runtimeEnv.FIRSTMATE_CAPTAIN_BLOCK = "${./captain-ralph.md}";
    text = builtins.readFile ./firstmate.sh;
  };

  firstmate-desk = pkgs.writeShellApplication {
    name = "firstmate-desk";
    runtimeInputs = with pkgs; [jq coreutils];
    text = builtins.readFile ./firstmate-desk.sh;
  };
in {
  # The toolchain goes on the user's PATH as well as the launcher's: each
  # crewmate runs in a herdr pane that starts a fresh login shell, which sees
  # home.packages and nothing the launcher put on its own PATH.
  home.packages = [firstmate firstmate-desk] ++ toolchain;
}
