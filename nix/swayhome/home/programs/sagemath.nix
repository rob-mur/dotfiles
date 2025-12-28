{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        sagemath = {
          enable = false;
        };
      };
    };
  };
}
