{config, ...}: let
in {
  services = {
        gnome-keyring = {
          enable = true;
    };
  };
}
