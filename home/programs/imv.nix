{config, ...}: let
in {
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
}
