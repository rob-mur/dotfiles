{config, pkgs, ...}: let
in {
  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi.override {
      commandLineArgs = ["--ozone-platform=x11"];
    };
  };
}
