{pkgs, ...}: {
  # Secrets dir: /var/lib/secrets/forgejo-runner-token must exist before the
  # runner service starts. File contents: `TOKEN=<registration-token>` (loaded
  # as a systemd EnvironmentFile, not a bare token — see upstream module).
  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0755 root root -"
    # Persistent per-user cache for jobs running as UID 1000 inside the
    # nix-host image. The /nix store is shared, so substitutions are local —
    # but nix's eval cache, devenv's cachix-trust file, and similar per-user
    # state live under ~/.cache and ~/.local/state. Without persistence each
    # job pays the eval-cache + cachix-trust penalty (~20s). Owner 1000:1000
    # to match the container user.
    "d /var/cache/forgejo-nix-host 0755 1000 1000 -"
    "d /var/cache/forgejo-nix-host/.cache 0755 1000 1000 -"
    "d /var/cache/forgejo-nix-host/.local 0755 1000 1000 -"
  ];

  # devenv must be on PATH inside job containers. systemPackages places it at
  # /nix/var/nix/profiles/system/sw/bin/devenv — a symlink chain that lives
  # entirely under /nix/store, so the /nix bind-mount makes it reachable from
  # the container. The image's PATH must include this directory.
  environment.systemPackages = [pkgs.devenv];

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.dev = {
      enable = true;
      name = "dev-desktop";
      url = "https://forgejo.clarob.uk";
      tokenFile = "/var/lib/secrets/forgejo-runner-token";
      # nix-host label: jobs that `runs-on: nix-host` get a minimal Debian
      # image with /nix bind-mounted from the host. They call the host's
      # nix daemon over the socket inside /nix/var/nix/daemon-socket/, which
      # accepts them because UID 1000 maps to host user `rob` (already in
      # trusted-users via nixos/system/nix.nix).
      labels = [
        "nix-host:docker://forgejo.clarob.uk/rob/nix-ci:latest"
      ];
      settings = {
        container = {
          network = "host";
          options = builtins.concatStringsSep " " [
            "-v /nix:/nix"
            "-v /var/cache/forgejo-nix-host/.cache:/home/ci/.cache"
            "-v /var/cache/forgejo-nix-host/.local:/home/ci/.local"
            "--user 1000:1000"
          ];
          valid_volumes = [
            "/nix"
            "/var/cache/forgejo-nix-host/.cache"
            "/var/cache/forgejo-nix-host/.local"
          ];
        };
      };
    };
  };

  # The upstream module runs as DynamicUser=yes — no extra user/group plumbing
  # needed. Container processes appear as UID 1000 to the host nix daemon
  # regardless of the runner's own dynamic UID.
}
