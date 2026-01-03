{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        ripgrep = {
          enable = true;
          arguments = [
            "--max-columns-preview"
            "--colors=line:style:bold"
          ];
        };
      };
    };
  };
}
