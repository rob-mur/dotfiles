{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        cliphist = {
          enable = true;
        };
      };
    };
  };
}
