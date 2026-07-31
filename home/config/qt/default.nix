{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs; let
  theme = import ./../../../user/theme {};
  breezeDarkColors = "${kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
in {
  # KDE apps (dolphin, ark, ...) read their palette from ~/.config/kdeglobals,
  # not from qt5ct/qt6ct. Without this the file keeps whatever colour scheme it
  # was last written with (Breeze *Light*), so light row backgrounds get paired
  # with the dark theme's near-white text and become unreadable.
  # kdeglobals must stay writable — KDE apps persist other settings into it —
  # so patch the colour groups in on activation rather than symlinking it.
  home.activation.kdeglobalsColorScheme =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      kdeglobals="${config.xdg.configHome}/kdeglobals"
      run mkdir -p "$(dirname "$kdeglobals")"
      run touch "$kdeglobals"
      {
        ${pkgs.gawk}/bin/awk '
          /^\[/ {
            group = $0
            skip = (group ~ /^\[Colors:/ || group ~ /^\[ColorEffects:/ || group ~ /^\[WM\]/)
            if (group == "[General]") seen_general = 1
          }
          # drop the old scheme name and its stale content hash
          group == "[General]" && /^ColorScheme(Hash)?=/ { next }
          group == "[General]" && !printed_scheme { print; print "ColorScheme=BreezeDark"; printed_scheme = 1; next }
          !skip { print }
          END { if (!seen_general) { print ""; print "[General]"; print "ColorScheme=BreezeDark" } }
        ' "$kdeglobals"
        ${pkgs.gawk}/bin/awk '
          /^#/ { next }
          /^\[/ { keep = ($0 ~ /^\[Colors:/ || $0 ~ /^\[ColorEffects:/ || $0 ~ /^\[WM\]/) }
          keep { print }
        ' ${breezeDarkColors}
      } > "$kdeglobals.hm-new"
      run mv "$kdeglobals.hm-new" "$kdeglobals"
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
