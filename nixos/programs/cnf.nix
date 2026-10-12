{...}: {
  # Off so home/programs/autobin.nix owns the command-not-found handler.
  # NixOS's handler is installed from /etc/zshrc and /etc/bashrc, which run
  # after ~/.zshenv and would replace autobin's with one that only prints a
  # `nix-shell -p` hint.
  programs.command-not-found.enable = false;
}
