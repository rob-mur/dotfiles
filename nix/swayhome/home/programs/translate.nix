{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        translate-shell = {
          enable = false;
          settings = {
            verbose = true;
          };
        };
      };
    };
  };
}
