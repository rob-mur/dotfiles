{
  config,
  lib,
  pkgs,
  ...
}: {
  # Nix Settings (User level)
  nix.settings = {
    extra-substituters = ["https://devenv.cachix.org"];
    extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
  };

  home.packages = with pkgs; [
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
    # sway utils
    wofi
    kanshi
  ];

  programs.zsh = {
    enable = true;
    # Adjusted to ensure it integrates with your existing zshrc setup if needed
    initExtra = ''
      if [ -f "${config.home.homeDirectory}/zsh/.zshrc" ]; then
         source "${config.home.homeDirectory}/zsh/.zshrc"
      fi
    '';
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.sessionVariables = {
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_NO_VENDER = "1";
    OPENSSL_LIB_DIR = "${pkgs.lib.getLib pkgs.openssl}/lib";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  # Ensure state version is consistent
  home.stateVersion = "23.05";
}
