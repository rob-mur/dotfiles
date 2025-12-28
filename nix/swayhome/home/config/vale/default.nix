{ ... }: let

  profile = import ./../../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      home = {
        file = {
          "vale" = {
            enable = false;
            source = ./dot_vale.ini;
            target = ".vale.ini";
          };
        };
      };
    };
  };
}
