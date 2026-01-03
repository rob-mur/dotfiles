{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        blueman-applet = {
          enable = false;
        };
      };
    };
  };
}
