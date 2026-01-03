{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        carapace = {
          enable = false;
        };
      };
    };
  };
}
