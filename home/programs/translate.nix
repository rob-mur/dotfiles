{config, ...}: let
in {
  programs = {
        translate-shell = {
          enable = false;
          settings = {
            verbose = true;
      };
    };
  };
}
