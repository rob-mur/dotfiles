{config, ...}: let
in {
  home = {
        file = {
          "vale" = {
            enable = false;
            source = ./dot_vale.ini;
            target = ".vale.ini";
      };
    };
  };
}
