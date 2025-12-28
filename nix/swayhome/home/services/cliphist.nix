{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        cliphist = {
          enable = true;
        };
      };
    };
  };
}
