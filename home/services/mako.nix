{config, ...}: let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};
in {
  home-manager = {
    users.${config.name} = {
      services = {
        mako = {
          enable = true;
          settings = {
            backgroundColor = color.f_background;
            borderColor = color.f_bright_blue;
            borderSize = "1";
            defaultTimeout = "5000"; # 5s
            font = "${theme.font} ${toString theme.font-size}";
            margin = "30";
            padding = "5";
            progressColor = "over ${color.f_bright_cyan}";
            textColor = color.f_foreground;
          };
        };
      };
    };
  };
}
