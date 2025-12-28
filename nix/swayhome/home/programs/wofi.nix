{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        wofi = {
          enable = false;
          settings = {
            location = "bottom-right";
            allow_markup = true;
            width = 400;
            height = 200;
          };
        };
      };
    };
  };
}
