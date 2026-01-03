{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        direnv = {
          enable = true;
        };
      };
    };
  };
}
