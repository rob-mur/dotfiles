{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        swayimg = {
          enable = true;
        };
      };
    };
  };
}
