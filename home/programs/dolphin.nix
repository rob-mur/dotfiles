{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      home.packages = [
        kdePackages.dolphin
        kdePackages.dolphin-plugins # For Git/Svn integration
        kdePackages.kdegraphics-thumbnailers # For image/PDF previews
        kdePackages.qtsvg # Required for many icons to display properly
        kdePackages.kio-extras
      ];
    };
  };
}
