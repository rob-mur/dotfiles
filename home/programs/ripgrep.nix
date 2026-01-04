{config, ...}: let
in {
  programs = {
        ripgrep = {
          enable = true;
          arguments = [
            "--max-columns-preview"
            "--colors=line:style:bold"
          ];
    };
  };
}
