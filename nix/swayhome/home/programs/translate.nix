{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        translate-shell = {
          enable = false;
          settings = {
            verbose = true;
          };
        };
      };
    };
  };
}
