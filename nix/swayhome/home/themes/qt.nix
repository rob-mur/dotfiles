{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
