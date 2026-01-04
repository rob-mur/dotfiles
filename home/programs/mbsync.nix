{config, ...}: let
in {
  programs = {
        mbsync = {
          enable = true;
          extraConfig = ''
            CopyArrivalDate yes
          '';
    };
  };
}
