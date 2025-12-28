{ ... }: let

  color = import ./../../user/color {};
  profile = import ./../../user/profile {};
  theme = import ./../../user/theme {};

in {
  home-manager = {
    users.${profile.name} = {
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
