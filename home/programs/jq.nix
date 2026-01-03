{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        jq = {
          enable = true;
        };
      };
    };
  };
}
