{
  pkgs,
  lib,
  osConfig,
  ...
}:
with pkgs; {
  home.packages = [
    # The upstream wrapper puts a bare nix alsa-lib on LD_LIBRARY_PATH for
    # voice input. On non-NixOS hosts the system ALSA config routes the
    # default PCM to the pipewire plugin, which that alsa-lib cannot find.
    # Point it at nix pipewire's ALSA plugins.
    (symlinkJoin {
      name = "claude-code-wrapped";
      paths = [pkgs-unstable.claude-code];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude \
          --set ALSA_PLUGIN_DIR "${pkgs-unstable.pipewire}/lib/alsa-lib"
      '';
    })
    pkgs-unstable.sox
  ];

  # Link the checkout's settings.json rather than a store copy: Claude Code
  # writes back to it (/model, /config, plugin installs), and those writes
  # should land in the repo where git can show them. Paths in it use $HOME,
  # since the username differs between hosts.
  #
  # A plain `ln`, not home.file with mkOutOfStoreSymlink: that goes through a
  # second symlink in the store, and Claude Code saves by writing a temp file
  # beside its link target, which fails there with EROFS.
  home.activation.claudeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.claude/hooks"
    run ln -sfn "${osConfig.hostDir}../../home/programs/claude-code/settings.json" "$HOME/.claude/settings.json"
    run ln -sfn "${osConfig.hostDir}../../home/programs/claude-code/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
    run ln -sfn "${osConfig.hostDir}../../home/programs/claude-code/subagent-wait-guard.sh" "$HOME/.claude/hooks/subagent-wait-guard.sh"
  '';
}
