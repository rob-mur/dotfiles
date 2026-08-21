{
  config,
  lib,
  ...
}: {
  # Standalone home-manager entry point for non-desktop, non-NixOS hosts
  # (e.g. a phone/tablet VM). Deliberately imports only CLI basics instead
  # of the full ./nixos.nix / ./standalone.nix module list, which pulls in
  # the whole Wayland desktop + GUI app stack.
  imports = [
    ./shell
    ./packages/basic/node.nix
    ./packages/basic/openssl.nix
    ./packages/basic/archive.nix
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/zsh.nix
    ./programs/autojump.nix
    ./programs/tmux.nix
    ./programs/fzf.nix
    ./programs/ripgrep.nix
    ./programs/jq.nix
    ./programs/direnv.nix
    ./programs/zoxide.nix
    ./programs/jj.nix
    ./programs/btop.nix
  ];

  # Stub options for NixOS-specific services that modules might reference
  # These prevent errors but have no effect in standalone mode
  options.services = {
    xserver = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for NixOS xserver service (non-functional in standalone mode)";
    };

    dbus = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for NixOS dbus service (non-functional in standalone mode)";
    };
  };

  config = {
    home = {
      username = config.name;
      homeDirectory = "/home/${config.name}";
      stateVersion = config.version;
      sessionPath = ["$HOME/.nix-profile/bin"];
    };

    # Plain editor, deliberately without the full kickstart plugin/LSP
    # config in ./programs/neovim.nix - that's a heavier setup better
    # suited to a desktop/laptop host. Swap it in later if this host
    # turns out to need it.
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    xdg.enable = true;
  };
}
