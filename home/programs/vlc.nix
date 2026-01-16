{
  pkgs,
  config,
  osConfig ? config,
  ...
}:
with pkgs; let
in {
  home.packages = with pkgs; [
    vlc
  ];
}
