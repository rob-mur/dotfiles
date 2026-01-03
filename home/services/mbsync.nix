{config, ...}: let
in {
  services = {
        mbsync = {
          enable = true;
          frequency = "*:0/2";
          verbose = true;
    };
  };
}
