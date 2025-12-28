{ ... }: let

  profile = import ./../../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
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
