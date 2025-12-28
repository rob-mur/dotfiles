{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        sqls = {
          enable = false;
          settings = {
            lowercaseKeywords = true;
            connections = [ ];
          };
        };
      };
    };
  };
}
