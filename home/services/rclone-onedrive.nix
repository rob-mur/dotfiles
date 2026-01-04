{
  pkgs,
  config,
  osConfig ? config,
  ...
}: let
in {
  home.packages = [pkgs.rclone];

  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "Rclone mount for OneDrive";
      After = ["network-online.target"];
    };

    Install = {
      WantedBy = ["default.target"];
    };

    Service = {
      Type = "simple";
      User = "${osConfig.name}";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Documents/OneDrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone --config %h/.config/rclone/rclone.conf \
          mount onedrive: %h/Documents/OneDrive \
          --vfs-cache-mode full \
          --vfs-read-chunk-size 128M \
          --allow-non-empty \
          -v
      '';
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/Documents/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = ["PATH=/run/wrappers/bin:/run/current-system/sw/bin"];
    };
  };
}
