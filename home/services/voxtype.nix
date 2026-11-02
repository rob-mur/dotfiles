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
      # Restrict Vulkan to the NVIDIA ICD so ggml doesn't pick the Intel iGPU.
      Environment = [
        "PATH=${pkgs.wtype}/bin:${pkgs.wl-clipboard}/bin:${pkgs.ydotool}/bin"
        "VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json"
      ];
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
