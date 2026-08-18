{pkgs, ...}:
with pkgs; {
  xdg = {
    portal = {
      enable = true;
      wlr = {
        enable = true;
        # The unit starts xdg-desktop-portal-wlr with an explicit --config, so
        # a config in ~/.config is ignored. Without a chooser_cmd the portal
        # falls back to dmenu clones that are not in the unit PATH, and every
        # ScreenCast request dies with "wlroots: no output found".
        settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          max_fps = 30;
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-hypr-remote
      ];
      config = {
        sway = {
          default = ["wlr" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
          "org.freedesktop.impl.portal.RemoteDesktop" = ["hypr-remote"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        };
      };
    };
  };
}
