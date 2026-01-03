{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [anki-bin];
}
