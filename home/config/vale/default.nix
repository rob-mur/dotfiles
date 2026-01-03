{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
