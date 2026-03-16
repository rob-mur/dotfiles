{pkgs, ...}: {
  systemd.user.services.xdg-desktop-portal-hypr-remote = {
    Unit = {
      Description = "Remote desktop portal backend using wlroots virtual input";
      Before = ["xdg-desktop-portal.service"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xdg-desktop-portal-hypr-remote}/bin/xdg-desktop-portal-hypr-remote";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["xdg-desktop-portal.service"];
    };
  };
}
