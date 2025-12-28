{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        xplr = {
          enable = false;
        };
      };
    };
  };
}
