{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      xdg = {
        configFile = {
          "activate-linux" = {
            enable = false;
            source = ./config.cfg;
            target = "./activate/config.cfg";
          };
        };
      };
    };
  };
}
