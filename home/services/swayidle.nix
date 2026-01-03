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
  services = {
        swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = lockcommand;
            }
            {
              event = "lock";
              command = lockcommand;
            }
            {
              event = "unlock";
              command = unlockcommand;
            }
            {
              event = "after-resume";
              command = resumecommand;
            }
          ];
          systemdTarget = "sway-session.target";
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
}
