{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        lf = {
          enable = false;
          settings = {
          };
        };
      };
    };
  };
}
