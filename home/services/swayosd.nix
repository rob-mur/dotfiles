{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        swayosd = {
          enable = false;
        };
      };
    };
  };
}
