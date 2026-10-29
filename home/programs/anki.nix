{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [pkgs-unstable.anki];
}
