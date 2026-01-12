{
  lib,
  pkgs,
  config,
  osConfig ? config,
  ...
}: let
  isWorkLaptop = osConfig.machineType == "work-laptop";
  fusermount =
    if isWorkLaptop
    then "${pkgs.fuse}/bin/fusermount"
    else "/run/wrappers/bin/fusermount";
in {
  home.packages = [
    pkgs.rclone
    pkgs.fuse
  ];

  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "Rclone mount for OneDrive";
      After = ["network-online.target"];
    };

    Install = {
      WantedBy = ["default.target"];
    };

    Service =
      {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Documents/OneDrive";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone --config %h/.config/rclone/rclone.conf \
            mount onedrive: %h/Documents/OneDrive \
            --vfs-cache-mode full \
            --vfs-read-chunk-size 128M \
            --allow-non-empty \
            -v
        '';
        ExecStop = "${fusermount} -u %h/Documents/OneDrive";
        Restart = "on-failure";
        RestartSec = "10s";
      }
      // lib.optionalAttrs (!isWorkLaptop) {
        Environment = ["PATH=/run/wrappers/bin:/run/current-system/sw/bin"];
      };
  };
}