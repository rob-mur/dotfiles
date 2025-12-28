{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        wlsunset = {
          enable = false;
          latitude = "-7.554360";
          longitude= "112.623016";
        };
      };
    };
  };
}
