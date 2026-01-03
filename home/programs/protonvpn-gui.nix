{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [protonvpn-gui];
}
