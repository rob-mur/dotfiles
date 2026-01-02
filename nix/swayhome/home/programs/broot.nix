{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        broot = {
          enable = false;
        };
      };
    };
  };
}
