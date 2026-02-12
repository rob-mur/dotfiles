{pkgs, ...}:
with pkgs; {
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        sway = {
          default = ["wlr" "gnome" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["kde"];
          "org.freedesktop.impl.portal.RemoteDesktop" = ["gnome"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        };
      };
    };
  };
}
