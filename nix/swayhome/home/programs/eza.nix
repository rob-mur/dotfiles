{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        eza = {
          enable = true;
          extraOptions = [ "--group-directories-first"  "--header" ];
          git = true;
        };
      };
    };
  };
}
