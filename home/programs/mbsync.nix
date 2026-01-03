{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        mbsync = {
          enable = true;
          extraConfig = ''
            CopyArrivalDate yes
          '';
        };
      };
    };
  };
}
