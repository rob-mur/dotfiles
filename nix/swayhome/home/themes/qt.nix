{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      qt = {
        enable = true;
        platformTheme = {
          name = "qtct";
        };
        style = {
          name = "breeze";
        };
      };
    };
  };
}
