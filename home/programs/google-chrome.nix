{
  config,
  pkgs,
  ...
}: let
in {
  programs.google-chrome = {
    enable = true;
    package = pkgs.google-chrome.override {
      commandLineArgs = ["--ozone-platform=x11" "--disable-setuid-sandbox" "--no-sandbox"];
    };
  };
}
