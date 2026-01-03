{config, ...}: let
in {
  xdg = {
        configFile = {
          "qutebrowser-script" = {
            enable = true;
            source = ./script;
            target = "./qutebrowser/greasemonkey";
      };
    };
  };
}
