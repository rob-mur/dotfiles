{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        msmtp = {
          enable = true;
        };
      };
    };
  };
}
