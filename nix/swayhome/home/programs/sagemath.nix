{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        sagemath = {
          enable = false;
        };
      };
    };
  };
}
