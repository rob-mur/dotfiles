{config, ...}: let
in {
  services = {
        blueman-applet = {
          enable = false;
    };
  };
}
