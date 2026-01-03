{config, ...}: let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};
in {
  home-manager = {
    users.${config.name} = {
      wayland = {
        windowManager = {
          sway = {
            swaynag = {
              enable = false;
              settings = {
                "<config>" = {
                  edge = "top";
                  font = "${theme.font} ${toString theme.font-size}";
                  background = color.background;
                  message-padding = 5;
                };
              };
            };
          };
        };
      };
    };
  };
}
