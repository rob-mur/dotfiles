{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        imv = {
          enable = true;
          settings = {
            options = {
              fullscreen = false;
            };
          };
        };
      };
    };
  };
}
