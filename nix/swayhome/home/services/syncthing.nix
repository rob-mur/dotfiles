{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        syncthing = {
          enable = true;
          tray = {
            enable = false;
          };
        };
      };
    };
  };
}
