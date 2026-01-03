{config, ...}: let
in {
  xdg = {
        configFile = {
          "activate-linux" = {
            enable = false;
            source = ./config.cfg;
            target = "./activate/config.cfg";
      };
    };
  };
}
