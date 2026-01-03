{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        java = {
          enable = false;
        };
      };
    };
  };
}
