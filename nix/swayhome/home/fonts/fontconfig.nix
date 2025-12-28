{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      fonts = {
        fontconfig = {
          enable = true;
        };
      };
    };
  };
}
