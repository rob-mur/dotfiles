{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        lf = {
          enable = false;
          settings = {
          };
        };
      };
    };
  };
}
