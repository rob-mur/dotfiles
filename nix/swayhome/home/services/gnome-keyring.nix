{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        gnome-keyring = {
          enable = true;
        };
      };
    };
  };
}
