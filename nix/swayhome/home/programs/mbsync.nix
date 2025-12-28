{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
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
