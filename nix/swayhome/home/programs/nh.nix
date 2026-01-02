{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        nh = {
          enable = false;
          clean = {
            enable = true;
          };
        };
      };
    };
  };
}
