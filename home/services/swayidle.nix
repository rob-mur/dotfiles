{
  pkgs,
  config,
  ...
}:
with pkgs; let
  lockcommand = "${swaylock}/bin/swaylock --daemonize";
  unlockcommand = "${procps}/bin/pkill -SIGUSR1 swaylock";

  timeoutcommand = "${sway}/bin/swaymsg \"output * dpms off\"";
  resumecommand = "${sway}/bin/swaymsg \"output * dpms on\"";
  suspendcommand = "${systemd}/bin/systemctl suspend";
in {
  home-manager = {
    users.${config.name} = {
      services = {
        swayidle = {
          enable = true;
          systemdTarget = "sway-session.target";
          events = {
            "before-sleep" = lockcommand;
            "lock" = lockcommand;
            "unlock" = unlockcommand;
            "after-resume" = resumecommand;
          };
          timeouts = [
            {
              timeout = 600; # 10m
              command = lockcommand;
            }
            {
              timeout = 1200; # 20m
              command = timeoutcommand;
              resumeCommand = resumecommand;
            }
            {
              timeout = 1800; # 30m
              command = suspendcommand;
            }
          ];
        };
      };
    };
  };
}
