{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        wlsunset = {
          enable = false;
          latitude = "-7.554360";
          longitude = "112.623016";
        };
      };
    };
  };
}
