{
  config,
  pkgs,
  ...
}: let
  wrappedVivaldi = pkgs.symlinkJoin {
    name = "vivaldi-wrapped";
    paths = [ (pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    }) ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/vivaldi \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdg-utils pkgs.kdePackages.dolphin ]}
    '';
  };
in {
  programs.vivaldi = {
    enable = true;
    package = wrappedVivaldi;
    commandLineArgs = [
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-setuid-sandbox"
    ];
  };
}
