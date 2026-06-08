{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [proton-vpn];
}
