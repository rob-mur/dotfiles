{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        mbsync = {
          enable = true;
          frequency = "*:0/2";
          verbose = true;
        };
      };
    };
  };
}
