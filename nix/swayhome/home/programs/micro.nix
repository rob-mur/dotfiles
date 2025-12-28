{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        micro = {
          enable = false;
          settings = {
          };
        };
      };
    };
  };
}
