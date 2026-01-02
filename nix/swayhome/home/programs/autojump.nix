{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        autojump = {
          enable = true;
        };
      };
    };
  };
}
