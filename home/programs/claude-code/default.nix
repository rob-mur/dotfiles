{
  pkgs,
  lib,
  osConfig,
  ...
}:
with pkgs; {
  home.packages = [pkgs-unstable.claude-code pkgs-unstable.sox];

  # Link the checkout's settings.json rather than a store copy: Claude Code
  # writes back to it (/model, /config, plugin installs), and those writes
  # should land in the repo where git can show them. Paths in it use $HOME,
  # since the username differs between hosts.
  #
  # A plain `ln`, not home.file with mkOutOfStoreSymlink: that goes through a
  # second symlink in the store, and Claude Code saves by writing a temp file
  # beside its link target, which fails there with EROFS.
  home.activation.claudeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.claude"
    run ln -sfn "${osConfig.hostDir}../../home/programs/claude-code/settings.json" "$HOME/.claude/settings.json"
  '';
}
