{ ... }: let

  profile = import ./../../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
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
