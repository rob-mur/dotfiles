{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [steam];
}
