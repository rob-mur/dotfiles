{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs.vivaldi.enable = true;
    };
  };
}
