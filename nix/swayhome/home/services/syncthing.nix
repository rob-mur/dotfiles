{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        syncthing = {
          enable = true;
          tray = {
            enable = false;
          };
        };
      };
    };
  };
}
