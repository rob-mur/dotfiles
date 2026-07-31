{config, ...}: let
in {
  qt = {
        enable = true;
        # Must agree with nixos/themes/qt.nix — "qtct" resolves to a plugin key
        # Qt6 does not provide, leaving Qt6 apps unthemed.
        platformTheme = {
          name = "kde";
        };
        style = {
          name = "breeze";
    };
  };
}
