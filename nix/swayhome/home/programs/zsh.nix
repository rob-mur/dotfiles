{pkgs, ...}: with pkgs; let

  abbr = import ./../../user/abbr {};
  plugins = import ../config/zsh/plugins.nix;
  profile = import ./../../user/profile {};

in {
home-manager = {
  users.${profile.name} = {

programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = abbr.abbr;
     history.size = 10000;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      inherit plugins;
    };
    # --- 3. Custom Startup Scripts & Init ---
    initContent = ''
        # Source a local file if it exists
        [[ -f ~/.local_zshrc ]] && source ~/.local_zshrc

        # Setup nvim as editor
        bindkey -v
        bind 'set show-mode-in-prompt on' 2>/dev/null
        bind 'set vi-ins-mode-string \1\e[6 q\2' 2>/dev/null
        bind 'set vi-cmd-mode-string \1\e[2 q\2' 2>/dev/null
        bindkey '^x^e' edit-command-line
        export EDITOR=nvim
    '';


    # --- 4. Extra Non-OMZ Plugins ---
    plugins = [
      {
        name = "zsh-system-clipboard";
        file = "zsh-system-clipboard.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "kutsan";
          repo = "zsh-system-clipboard";
          rev = "v0.8.0";
          sha256 = "sha256-VWTEJGudlQlNwLOUfpo0fvh0MyA2DqV+aieNPx/WzSI=";
        };
      }
    ];
  };

  home.sessionVariables = {

    ZSH_SYSTEM_CLIPBOARD_USE_WL_CLIPBOARD = "true";

  };
};
};
}
