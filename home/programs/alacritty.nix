{config, ...}: let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        alacritty = {
          enable = false;
          settings = {
            colors = {
              primary = {
                foreground = color.h_foreground;
                background = color.h_background;
              };
              normal = {
                black = color.h_black;
                red = color.h_red;
                green = color.h_green;
                yellow = color.h_yellow;
                blue = color.h_blue;
                magenta = color.h_purple;
                cyan = color.h_cyan;
                white = color.h_white;
              };
              bright = {
                black = color.h_bright_black;
                red = color.h_bright_red;
                green = color.h_bright_green;
                yellow = color.h_bright_yellow;
                blue = color.h_bright_blue;
                magenta = color.h_bright_purple;
                cyan = color.h_bright_cyan;
                white = color.h_bright_white;
              };
            };
            font = {
              size = theme.font-size;
              normal = {
                family = "${theme.font-mono}";
                style = "Regular";
              };
            };
            window = {
              padding = {
                x = 15;
                y = 15;
              };
            };
          };
        };
      };
    };
  };
}
