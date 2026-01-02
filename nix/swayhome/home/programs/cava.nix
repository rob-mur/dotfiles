{config, ...}: let
  color = import ./../../user/color {};
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        cava = {
          enable = true;
          settings = {
            general = {
              framerate = 60;
              bars = 0;
              bar_width = 1;
              bar_spacing = 1;
            };
            smoothing = {
              noise_reduction = 88;
            };
            color = {
              gradient = 1;
              gradient_count = 3;
              gradient_color_1 = color.q_bright_blue;
              gradient_color_2 = color.q_bright_cyan;
              gradient_color_3 = color.q_bright_yellow;
            };
          };
        };
      };
    };
  };
}
