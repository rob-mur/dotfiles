# Switches the KDE/Qt colour scheme between Breeze Dark and Breeze Light.
#
# Everything Qt reads comes from ~/.config/kdeglobals (see nixos/themes/qt.nix
# for why platformTheme must be "kde"), so switching themes means rewriting the
# [Colors:*] groups in that file. It has to stay writable — KDE apps persist
# unrelated settings into it — so this merges the managed groups in rather than
# replacing the file, and is safe to run repeatedly.
#
# Modes:
#   dark | light  force a scheme
#   toggle        flip to the other one   (bound to a key in home/wayland/sway.nix)
#   keep          re-apply the current one, defaulting to dark when unset.
#                 Used at activation so a rebuild re-pins fonts/icons without
#                 clobbering a light scheme the user toggled to.
{pkgs}: let
  theme = import ./../../../user/theme {};
  # KF6 font format: family,size,-1,5,weight,italic,underline,strikeout,fixed-pitch,...
  qtFont = "${theme.font},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
  qtFontMono = "${theme.font-mono},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
  # theme.icon is the dark variant; Papirus-Dark -> Papirus for the light scheme.
  iconDark = theme.icon;
  iconLight = pkgs.lib.removeSuffix "-Dark" theme.icon;
in
  pkgs.writeShellApplication {
    name = "set-color-scheme";
    runtimeInputs = [pkgs.gawk pkgs.coreutils pkgs.gnugrep pkgs.dconf pkgs.glib];
    text = ''
      mode="''${1:-toggle}"
      kdeglobals="''${XDG_CONFIG_HOME:-$HOME/.config}/kdeglobals"
      schemes="${pkgs.kdePackages.breeze}/share/color-schemes"

      current=Dark
      if grep -q '^ColorScheme=BreezeLight' "$kdeglobals" 2>/dev/null; then
        current=Light
      fi

      case "$mode" in
        dark)   target=Dark ;;
        light)  target=Light ;;
        keep)   target="$current" ;;
        toggle) if [ "$current" = Dark ]; then target=Light; else target=Dark; fi ;;
        *) echo "usage: set-color-scheme [dark|light|toggle|keep]" >&2; exit 2 ;;
      esac

      if [ "$target" = Dark ]; then
        icon=${iconDark}
        prefer='prefer-dark'
      else
        icon=${iconLight}
        prefer='prefer-light'
      fi

      mkdir -p "$(dirname "$kdeglobals")"
      touch "$kdeglobals"

      {
        awk -v F='${qtFont}' -v M='${qtFontMono}' -v SCHEME="Breeze$target" -v ICON="$icon" '
          /^\[/ {
            group = $0
            skip = (group ~ /^\[Colors:/ || group ~ /^\[ColorEffects:/ || group ~ /^\[WM\]/ || group ~ /^\[Icons\]/)
            if (group == "[General]") seen_general = 1
          }
          # drop the keys we manage; they are re-emitted below
          group == "[General]" && /^(ColorScheme|ColorSchemeHash|font|fixed|smallestReadableFont|toolBarFont|menuFont)=/ { next }
          group == "[General]" && !printed_general {
            print
            print "ColorScheme=" SCHEME
            print "font=" F
            print "fixed=" M
            print "smallestReadableFont=" F
            print "toolBarFont=" F
            print "menuFont=" F
            printed_general = 1
            next
          }
          !skip { print }
          END {
            if (!seen_general) {
              print ""
              print "[General]"
              print "ColorScheme=" SCHEME
              print "font=" F
              print "fixed=" M
              print "smallestReadableFont=" F
              print "toolBarFont=" F
              print "menuFont=" F
            }
            print ""
            print "[Icons]"
            print "Theme=" ICON
          }
        ' "$kdeglobals"
        awk '
          /^#/ { next }
          /^\[/ { keep = ($0 ~ /^\[Colors:/ || $0 ~ /^\[ColorEffects:/ || $0 ~ /^\[WM\]/) }
          keep { print }
        ' "$schemes/Breeze$target.colors"
      } | cat -s > "$kdeglobals.new"

      mv "$kdeglobals.new" "$kdeglobals"
      chmod 600 "$kdeglobals"

      # Session-only steps. Absent at activation time, when there is no bus.
      if [ -n "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        # The portal's dark-mode preference. GTK4/libadwaita apps, Firefox and
        # Chromium follow this live; GTK3 apps read gtk-3.0/settings.ini
        # instead and stay on whatever theme home-manager pinned there.
        dconf write /org/gnome/desktop/interface/color-scheme "'$prefer'" || true
        dconf write /org/gnome/desktop/interface/icon-theme "'$icon'" || true

        # Ask running KDE apps to re-read kdeglobals. Outside a Plasma session
        # most ignore it, so treat a restart as the reliable path — this is
        # best-effort only.
        gdbus emit --session --object-path /kdeglobals \
          --signal org.kde.kconfig.notify.ConfigChanged \
          "{'General': ['ColorScheme'], 'Colors:View': ['BackgroundNormal']}" || true
      fi

      echo "colour scheme: Breeze$target"
    '';
  }
