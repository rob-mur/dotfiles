{pkgs, ...}: {
  # Secrets dir: /var/lib/secrets/forgejo-runner-token must exist before the
  # runner service starts. File contents: `TOKEN=<registration-token>` (loaded
  # as a systemd EnvironmentFile, not a bare token — see upstream module).
  #
  # Cache dir: /var/cache/forgejo-devenv is mounted into job containers so the
  # devenv/nix cache persists across runs. World-writable so whatever uid the
  # job image runs as (e.g. 1000:100 for ghcr.io/cachix/devenv/devenv) can
  # populate it. Lives in /var/cache (not /tmp) so it survives reboots.
  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0755 root root -"
    "d /var/cache/forgejo-devenv 0777 root root -"
  ];

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.dev = {
      enable = true;
      name = "dev-desktop";
      url = "https://forgejo.clarob.uk";
      tokenFile = "/var/lib/secrets/forgejo-runner-token";
      labels = ["docker:docker://node:20-bookworm"];
      settings = {
        container = {
          network = "host";
          valid_volumes = [
            "/var/cache/forgejo-devenv"
          ];
        };
      };
    };
  };

  # The upstream module runs as DynamicUser=yes and auto-adds the `docker`
  # supplementary group when a `:docker:` label is present and
  # virtualisation.docker is enabled — no extra user/group plumbing needed.
}
