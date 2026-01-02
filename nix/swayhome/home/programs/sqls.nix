{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        sqls = {
          enable = false;
          settings = {
            lowercaseKeywords = true;
            connections = [];
          };
        };
      };
    };
  };
}
