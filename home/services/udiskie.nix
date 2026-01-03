{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        udiskie = {
          enable = true;
          automount = true;
          notify = true;
          tray = "never";
        };
      };
    };
  };
}
