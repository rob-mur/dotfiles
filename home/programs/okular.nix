{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [
        kdePackages.okular
        kdePackages.qtsvg # Required for many icons to display properly
      ];
}
