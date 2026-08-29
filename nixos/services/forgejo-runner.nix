{pkgs, ...}: let
  # The job container does not inherit the host's nix.conf, so every new-CLI
  # `nix` subcommand fails inside a job unless the workflow passes
  # --extra-experimental-features itself. Bind this in at /etc/nix/nix.conf so
  # the client inside the container has flakes on. The store path lives under
  # /nix, which is already bind-mounted, so it resolves in the container.
  ciNixConf = pkgs.writeText "ci-nix.conf" ''
    experimental-features = nix-command flakes
  '';
in {
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
    #
    # Known deviation from the cd-pipeline machine contract (#35, outcome 3:
    # "/nix/store survives between jobs, and nothing else does"). These two
    # directories also survive. They hold evaluation state, not store paths,
    # so a job still cannot read the previous job's workspace. Kept on
    # purpose for the ~20s; recorded so a verb that starts lying has a
    # suspect list.
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
        runner.capacity = 4;
        container = {
          # Jobs share the host network namespace, so a leaked process holds a
          # host port and capacity 4 makes a collision routine. Relevant to
          # cd-pipeline HP13 clause 3; left as-is because the nix daemon socket
          # and the forge are both reached this way today.
          network = "host";
          options = builtins.concatStringsSep " " [
            "-v /nix:/nix"
            "-v ${ciNixConf}:/etc/nix/nix.conf:ro"
            "-v /var/cache/forgejo-nix-host/.cache:/home/ci/.cache"
            "-v /var/cache/forgejo-nix-host/.local:/home/ci/.local"
            "--user 1000:1000"
          ];
          valid_volumes = [
            "/nix"
            "${ciNixConf}"
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
