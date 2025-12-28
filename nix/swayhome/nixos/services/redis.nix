{ ... }: let

  profile = import ./../../user/profile {};

in {
  services = {
    redis = {
      servers = {
        "${profile.hostname}" = {
          enable = false;
          port = 6379;
        };
      };
    };
  };
}
