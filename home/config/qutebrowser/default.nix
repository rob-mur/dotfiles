{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      xdg = {
        configFile = {
          "qutebrowser-script" = {
            enable = true;
            source = ./script;
            target = "./qutebrowser/greasemonkey";
          };
        };
      };
    };
  };
}
