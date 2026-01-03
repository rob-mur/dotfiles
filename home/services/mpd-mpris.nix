{config, ...}: let
in {
  services = {
        mpd-mpris = {
          enable = true;
    };
  };
}
