{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
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
