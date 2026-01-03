{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        xplr = {
          enable = false;
        };
      };
    };
  };
}
