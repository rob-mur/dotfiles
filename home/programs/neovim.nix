{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.file.".undodir/.keep".text = "";
      xdg.configFile."nvim" = {
        source = ../config/nvim;
        recursive = true;
      };

      # LSPs (non lazy)
      home.packages = with pkgs; [
        basedpyright
      ];

      programs = {
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
          withPython3 = true;
    };
  };
}
