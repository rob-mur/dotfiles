{config, ...}: let
in {
  services = {
    redis = {
      servers = {
        "${config.hostname}" = {
          enable = false;
          port = 6379;
        };
      };
    };
  };
}
