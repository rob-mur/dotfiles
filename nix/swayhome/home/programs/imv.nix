{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        imv = {
          enable = true;
          settings = {
            options = {
              fullscreen = false;
            };
          };
        };
      };
    };
  };
}
