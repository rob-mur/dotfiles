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
          # Sets EDITOR in home.sessionVariables, which .zshenv loads, so
          # non-interactive processes such as the herdr server see nvim too
          # (prefix+e edit_scrollback). /etc/set-environment says nano.
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
          withPython3 = true;
          withRuby = false;
    };
  };
}
