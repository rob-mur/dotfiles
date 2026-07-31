{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  theme = import ./../../../user/theme {};
  setColorScheme = import ./color-scheme.nix {inherit pkgs;};
in {
  # set-color-scheme owns ~/.config/kdeglobals: palette, fonts and icon theme
  # for every Qt app (qt.platformTheme = "kde" makes that file the single
  # source of truth). It is also what the Mod4+Shift+d binding in
  # home/wayland/sway.nix runs to flip dark/light.
  home.packages = [setColorScheme];

  # "keep" re-pins fonts/icons on every rebuild while preserving whichever
  # scheme is currently selected, so a rebuild never undoes a toggle. Without
  # this the file drifts back to whatever last wrote it — Breeze *Light*, which
  # pairs light row backgrounds with near-white text and makes dolphin's file
  # names unreadable.
  home.activation.kdeglobalsColorScheme =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${setColorScheme}/bin/set-color-scheme keep
    '';

  xdg = {
        configFile = {
          "qt5ct" = {
            enable = true;
            force = true;
            target = "./qt5ct/qt5ct.conf";
            text = ''
              [Appearance]
              color_scheme_path=${libsForQt5.qt5ct}/share/qt5ct/colors/darker.conf
              custom_palette=true
              icon_theme=Papirus-Dark
              standard_dialogs=default
              style=Fusion

              [Fonts]
              fixed="${theme.font},${toString theme.font-size},-1,5,50,0,0,0,0,0,Regular"
              general="${theme.font},${toString theme.font-size},-1,5,50,0,0,0,0,0,Regular"
            '';
          };
          "qt6ct" = {
            enable = true;
            force = true;
            target = "./qt6ct/qt6ct.conf";
            text = ''
              [Appearance]
              color_scheme_path=${kdePackages.qt6ct}/share/qt6ct/colors/darker.conf
              custom_palette=true
              icon_theme=Papirus-Dark
              standard_dialogs=default
              style=Breeze

              [Fonts]
              fixed="${theme.font},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
              general="${theme.font},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
            '';
      };
    };
  };
}
