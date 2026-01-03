{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      fonts = {
        fontconfig = {
          enable = true;
        };
      };
    };
  };
}
