{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [signal-desktop];
}
