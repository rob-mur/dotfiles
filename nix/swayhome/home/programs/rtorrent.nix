{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        rtorrent = {
          enable = true;
        };
      };
    };
  };
}
