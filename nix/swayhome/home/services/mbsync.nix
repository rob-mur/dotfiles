{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        mbsync = {
          enable = true;
          frequency = "*:0/2";
          verbose = true;
        };
      };
    };
  };
}
