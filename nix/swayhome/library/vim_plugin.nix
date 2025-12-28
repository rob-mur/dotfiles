{
  pkgs,
  vimp_withplugin ? true,
  ...
}:
with pkgs;
let

  vim_plugin_list =
    if vimp_withplugin then with vimPlugins; [
      coc-clangd
      coc-clap
      coc-cmake
      coc-css
      coc-denite
      coc-diagnostic
      coc-docker
      coc-emmet
      coc-eslint
      coc-explorer
      coc-flutter
      coc-fzf
      coc-git
      coc-go
      coc-haxe
      coc-highlight
      coc-html
      coc-java
      coc-jest
      coc-json
      coc-lists
      coc-lua
      coc-markdownlint
      coc-neco
      coc-nginx
      coc-nvim
      coc-pairs
      coc-prettier
      coc-pyright
      coc-r-lsp
      coc-rust-analyzer
      coc-sh
      coc-smartf
      coc-snippets
      coc-solargraph
      coc-spell-checker
      coc-sqlfluff
      coc-stylelint
      coc-sumneko-lua
      coc-svelte
      coc-tailwindcss
      coc-texlab
      coc-toml
      coc-tsserver
      coc-vimlsp
      coc-vimtex
      coc-wxml
      coc-yaml
      coc-yank
      julia-vim
      nvim-autopairs
      nvim-jdtls
      nvim-lastplace
      nvim-metals
      nvim-web-devicons
      scope-nvim
      scrollbar-nvim
      statix
      surround-nvim
      tabline-nvim
      telescope-nvim
      vim-airline
      vim-airline-themes
      vim-commentary
      vim-lightline-coc
      vim-nix
      vim-wayland-clipboard
    ]
    else
      [];

in {

  inherit pkgs vimPlugins;
  inherit vim_plugin_list;

}

