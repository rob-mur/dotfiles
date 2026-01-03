{config, ...}: let
in {
  programs = {
        nh = {
          enable = false;
          clean = {
            enable = true;
      };
    };
  };
}
