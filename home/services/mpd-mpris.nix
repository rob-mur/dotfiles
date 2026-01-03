{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        mpd-mpris = {
          enable = true;
        };
      };
    };
  };
}
