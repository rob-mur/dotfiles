{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        eza = {
          enable = true;
          extraOptions = ["--group-directories-first" "--header"];
          git = true;
        };
      };
    };
  };
}
