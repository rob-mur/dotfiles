{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};
  vim_plugin = import ./../../library/vim_plugin.nix {
    inherit pkgs vim_Plugins;
    inherit vim_plugin_list;
  };

in {
  home-manager = {
    users.${profile.name} = {

	home.file.".undodir/.keep".text = "";
      xdg.configFile."nvim" = {
        source = ../config/nvim; 
    recursive = true;
  };
      programs = {
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
          withPython3 = true;
          withRuby = true;
          plugins = vim_plugin.vim_plugin_list;
          extraConfig = ''
            filetype indent on
            filetype on
            colorscheme vim
            set backspace=indent,eol,start
            set expandtab
            set history=1000
            set hlsearch
            set ignorecase
            set incsearch
            set linebreak breakindent
            set list listchars=tab:>>,trail:~
            set nobackup
            set nocompatible
            set nowrap
            set nomodified
            set number relativenumber
            set scrolloff=10
            set shiftwidth=2
            set showcmd
            set showmatch
            set showmode
            set smartcase
            set smarttab
            set splitbelow
            set splitright
            set t_Co=256
            set tabstop=2
            set undofile
            set undolevels=50000
            set updatetime=100
            syntax on

            let g:mapleader = "\<Space>"
            let g:airline_theme = "base16_default_dark"

            tnoremap <Esc> <C-\><C-n>
            tnoremap <A-h> <C-\><C-N><C-w>h
            tnoremap <A-j> <C-\><C-N><C-w>j
            tnoremap <A-k> <C-\><C-N><C-w>k
            tnoremap <A-l> <C-\><C-N><C-w>l
            inoremap <A-h> <C-\><C-N><C-w>h
            inoremap <A-j> <C-\><C-N><C-w>j
            inoremap <A-k> <C-\><C-N><C-w>k
            inoremap <A-l> <C-\><C-N><C-w>l
            nnoremap <A-h> <C-w>h
            nnoremap <A-j> <C-w>j
            nnoremap <A-k> <C-w>k
            nnoremap <A-l> <C-w>l
            nnoremap <silent> <Left> :vertical resize +2<CR>
            nnoremap <silent> <Right> :vertical resize -2<CR>
            nnoremap <silent> <Up> :resize +2<CR>
            nnoremap <silent> <Down> :resize -2<CR>
            nnoremap <silent> = <C-w>=
            vnoremap <silent> > >gv
            vnoremap <silent> < <gv
            nnoremap <silent> _ <C-W>s<C-W><Down>
            nnoremap <silent> <Bar> <C-W>v<C-W><Right>
            nnoremap <silent> <Leader>q :q<CR>
            nnoremap <silent> <leader>Q :bd<CR>
            nnoremap <silent> <leader>w :w<CR>
            vnoremap <leader>y "qygv<ESC>
            vnoremap <leader>x "+ygvd<ESC>
            nnoremap <silent> <Leader>t :terminal<CR>
          '';
          coc = {
            enable = true;
            pluginConfig = ''
              nnoremap <silent> <leader>e :CocCommand explorer
                \ --sources=buffer+,file+<CR>

              function! CheckBackspace() abort
                let col = col('.') - 1
                return !col || getline('.')[col - 1]  =~# '\s'
              endfunction

              inoremap <silent><expr> <Tab>
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ CheckBackspace() ? "\<Tab>" :
                \ coc#refresh()

              inoremap <expr> <Tab>
                \ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"

              inoremap <expr> <S-Tab>
                \ coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

              inoremap <silent><expr> <CR>
                \ coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
            '';
          };
        };
      };
    };
  };
}
