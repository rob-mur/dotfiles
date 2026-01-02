{pkgs, ...}:
with pkgs; {
  xdg = {
    portal = {
      enable = true;

      configPackages = [pkgs.xdg-desktop-portal-gtk];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
