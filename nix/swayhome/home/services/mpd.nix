{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        mpd = {
          enable = true;
          musicDirectory = "/home/${profile.name}/music";
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
    };
  };
}
