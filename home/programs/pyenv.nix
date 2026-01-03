{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        pyenv = {
          enable = true;
        };
      };
    };
  };
}
