{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        rtorrent = {
          enable = true;
        };
      };
    };
  };
}
