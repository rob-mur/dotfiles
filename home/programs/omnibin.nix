{
  config,
  pkgs,
  ...
}: let
  # Same locations the service mounts at (%t). XDG_RUNTIME_DIR isn't set in
  # every session (e.g. SSH without pam_systemd), hence the fallback.
  runtime = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}";
  tree = "${runtime}/omnibin";
  store = "${runtime}/omnibin-store";

  # Joins the always-on mount below instead of making one: a private mount
  # namespace with the lazy store bound over /nix/store, and the tree last on
  # PATH (same as omnibin-shell's inner half). Only this shell and its
  # children see it; the rest of the system, and Nix itself, keep the real
  # store. Falls back to plain omnibin-shell if the service isn't up.
  inner = pkgs.writeShellScript "omni-inner" ''
    set -eu
    mount --bind "$OMNIBIN_STORE" /nix/store
    export PATH="$PATH:$OMNIBIN_TREE/bin"
    exec "$@"
  '';
  omni = pkgs.writeShellScriptBin "omni" ''
    set -eu
    export OMNIBIN_TREE="${tree}" OMNIBIN_STORE="${store}"
    [ "$#" -eq 0 ] && set -- "''${SHELL:-/bin/sh}"
    if [ -e "$OMNIBIN_TREE/README.md" ]; then
      exec ${pkgs.util-linux}/bin/unshare --user --map-root-user --mount -- ${inner} "$@"
    fi
    echo "omni: omnibin service not running, mounting just for this shell" >&2
    exec ${pkgs.omnibin-shell}/bin/omnibin-shell "$@"
  '';
in {
  # omnibin: every executable nixpkgs ever shipped, fetched lazily from
  # cache.nixos.org on first read. `pkgs.omnibin` / `pkgs.omnibin-shell` come
  # from the omnibin flake via an overlay in the host flake.
  #
  # Mounting as the calling user needs a setuid fusermount3 at
  # /run/wrappers/bin. That part can't live in home-manager; the host flake's
  # systemConfigs (system-manager) provides it, and nixpkgs' libfuse looks
  # for it there directly.
  #
  # omnibin-shell itself isn't installed: it unmounts whatever is at these
  # paths before mounting its own, which would take the service's mount down.
  home.packages = [pkgs.omnibin omni];

  # Keeps the lazy store mounted in the user's runtime dir, so `omni` starts
  # instantly and the browsable tree is always there. Deliberately not
  # upstream's NixOS module shape (lazy store over the real /nix/store for the
  # whole system): that breaks Nix itself and takes every binary down with it
  # if omnibin dies.
  systemd.user.services.omnibin = {
    Unit = {
      Description = "omnibin lazy Nix store";
      After = ["network-online.target"];
    };
    Service = {
      ExecStartPre = [
        # A killed run leaves stale FUSE mounts that refuse even stat().
        "-/run/wrappers/bin/fusermount3 -u %t/omnibin"
        "-/run/wrappers/bin/fusermount3 -u %t/omnibin-store"
        "${pkgs.coreutils}/bin/mkdir -p %t/omnibin %t/omnibin-store ${config.xdg.cacheHome}/omnibin"
      ];
      ExecStart = "${pkgs.omnibin}/bin/omnibin mount --store %t/omnibin-store --passthrough /nix/store --tree %t/omnibin --cache-dir ${config.xdg.cacheHome}/omnibin";
      ExecStopPost = [
        "-/run/wrappers/bin/fusermount3 -u %t/omnibin"
        "-/run/wrappers/bin/fusermount3 -u %t/omnibin-store"
      ];
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
