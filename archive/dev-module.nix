{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.package = pkgs.nix;
  nix.settings = {
    extra-substituters = ["https://devenv.cachix.org"];
    extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
    experimental-features = ["nix-command" "flakes"];
  };

  # For application shortcuts
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    # git
    gh
    neovim
    tmux
    autojump
    devenv
    uv
    # Languages/Runtimes
    python3
    nodejs_24
    rustup
    gcc
    # Version Control
    jujutsu
    lazyjj
    # Language Servers
    basedpyright
    # Formatters/Linters
    nixfmt-classic
    stylua
    nodePackages.prettier
    alejandra
    black
    # Utilities
    ripgrep
    eza
    devbox
    jq
    lsof
    wl-clipboard
    qwerty-fr
    openssh
    gnumake
    blueberry
    # LLM
    gemini-cli
    # sway
    wofi
    kanshi
  ];

  programs.zsh = {
    enable = true;
    initContent = ''
             source "${config.home.homeDirectory}/zsh/.zshrc"

      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
               . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
             fi
    '';
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.direnv.enable = true;

  home.sessionVariables = {
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_NO_VENDER = "1";
    OPENSSL_LIB_DIR = "${pkgs.lib.getLib pkgs.openssl}/lib";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  home.username = "rob";
  home.homeDirectory = "/home/rob";
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}

