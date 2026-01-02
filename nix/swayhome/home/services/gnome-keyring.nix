{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        gnome-keyring = {
          enable = true;
        };
      };
    };
  };
}
