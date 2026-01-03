{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        vifm = {
          enable = false;
        };
      };
    };
  };
}
