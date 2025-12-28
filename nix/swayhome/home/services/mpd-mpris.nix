{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        mpd-mpris = {
          enable = true;
        };
      };
    };
  };
}
