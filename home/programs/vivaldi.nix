{
  config,
  pkgs,
  ...
}: let
in {
  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    };
    commandLineArgs = [
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-setuid-sandbox"
    ];
  };
}
