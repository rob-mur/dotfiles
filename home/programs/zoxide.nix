{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        zoxide = {
          enable = true;
        };
      };
    };
  };
}
