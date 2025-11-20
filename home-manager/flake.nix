{
  description = "Portable development environment for Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    devModule = {
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
        # LLM
        gemini-cli
        # sway
        wofi
      ];

      programs.zsh = {
        enable = true;
        initContent = ''
          source "${config.home.homeDirectory}/zsh/.zshrc"
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

      home.username = "robert.murphy";
      home.homeDirectory = "/home/robert.murphy";
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
    };
  in {
    homeConfigurations = {
      "rmurphy@dev" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          devModule
        ];
      };
    };

    # Expose the module so it can be used in other flakes
    homeManagerModules.dev = devModule;
  };
}
