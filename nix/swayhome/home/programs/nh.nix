{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        nh = {
          enable = false;
          clean = {
            enable = true;
          };
        };
      };
    };
  };
}
