{pkgs, ...}: {
  # Secrets dir: /var/lib/secrets/forgejo-runner-token must exist before the
  # runner service starts. File contents: `TOKEN=<registration-token>` (loaded
  # as a systemd EnvironmentFile, not a bare token — see upstream module).
  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0755 root root -"
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
          options = "-v /nix:/nix --user 1000:1000";
          valid_volumes = [
            "/nix"
          ];
        };
      };
    };
  };

  # The upstream module runs as DynamicUser=yes — no extra user/group plumbing
  # needed. Container processes appear as UID 1000 to the host nix daemon
  # regardless of the runner's own dynamic UID.
}
