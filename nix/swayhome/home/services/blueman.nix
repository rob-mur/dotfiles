{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        blueman-applet = {
          enable = false;
        };
      };
    };
  };
}
