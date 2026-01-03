{config, ...}: let
in {
  services = {
        syncthing = {
          enable = true;
          tray = {
            enable = false;
      };
    };
  };
}
