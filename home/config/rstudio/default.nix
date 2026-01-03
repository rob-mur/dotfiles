{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      home = {
        file = {
          "rprofile" = {
            enable = true;
            target = ".Rprofile";
            text = ''
              library("IRkernel")
              library("quarto")
              library("reticulate")
            '';
          };
        };
      };
      xdg = {
        configFile = {
          "rstudio-themes" = {
            enable = true;
            source = ./breeze-dark.rstheme;
            target = "./rstudio/themes/breeze-dark.rstheme";
          };
          "rstudio-prefs" = {
            enable = true;
            source = ./rstudio-prefs.json;
            target = "./rstudio/rstudio-prefs.json";
          };
        };
      };
    };
  };
}
