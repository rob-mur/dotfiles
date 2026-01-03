{config, ...}: let
  theme = import ./../../user/theme {};
in {
  home-manager = {
    users.${config.name} = {
      services = {
        xsettingsd = {
          enable = true;
          settings = {
            "Gtk/ButtonImages" = 0;
            "Gtk/CursorThemeName" = "${theme.cursor}";
            "Gtk/CursorThemeSize" = theme.cursor-size;
            "Gtk/DecorationLayout" = "icon:minimize,maximize,close";
            "Gtk/EnableAnimations" = 1;
            "Gtk/FontName" = "${theme.font} ${toString theme.font-size}";
            "Gtk/KeyThemeName" = "Default";
            "Gtk/MenuImages" = 0;
            "Gtk/OverlayScrolling" = 1;
            "Gtk/PrimaryButtonWarpsSlider" = 0;
            "Gtk/ToolbarStyle" = 3;
            "Gtk/WindowScalingFactor" = 1;
            "Net/IconThemeName" = "${theme.icon}";
            "Net/ThemeName" = "${theme.theme}";
            "Xft/Antialias" = 1;
            "Xft/DPI" = 98304;
            "Xft/HintStyle" = "hintslight";
            "Xft/Hinting" = 1;
            "Xft/RGBA" = "none";
          };
        };
      };
    };
  };
}
