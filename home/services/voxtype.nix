{pkgs, ...}: {
  # Dictation daemon. Config comes from home/programs/voxtype; the sway
  # keybind drives it with `voxtype record start|stop`.
  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype push-to-talk dictation";
      After = ["graphical-session.target" "pipewire.service"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.pkgs-unstable.voxtype-vulkan}/bin/voxtype daemon";
      # wtype must be on PATH for the typing driver.
      Environment = "PATH=${pkgs.wtype}/bin:${pkgs.wl-clipboard}/bin:${pkgs.ydotool}/bin";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
