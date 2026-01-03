{config, ...}: let
in {
  services = {
        mpd = {
          enable = true;
          musicDirectory = "/home/${config.name}/music";
          extraConfig = ''
            auto_update    "yes"
            restore_paused "yes"
            audio_output {
              type         "pipewire"
              name         "pipewire-output"
            }
            audio_output {
              type         "fifo"
              name         "visualizer"
              format       "44100:16:2"
              path         "/tmp/mpd.fifo"
            }
          '';
    };
  };
}
