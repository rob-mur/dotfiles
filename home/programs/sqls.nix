{config, ...}: let
in {
  programs = {
        sqls = {
          enable = false;
          settings = {
            lowercaseKeywords = true;
            connections = [];
      };
    };
  };
}
