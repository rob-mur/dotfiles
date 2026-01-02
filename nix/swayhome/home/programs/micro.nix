{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        micro = {
          enable = false;
          settings = {
          };
        };
      };
    };
  };
}
