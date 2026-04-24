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

  # nix.conf for job containers: configure the host's /nix/store as a local
  # file-based substituter. Workflows bind-mount the host store read-only at
  # /mnt/host-nix-store (a side path, not /nix/store itself — bind-mounting
  # over /nix/store would shadow the devenv image's own binaries and the
  # container wouldn't start). Any path already built on the host is served
  # via a plain FS copy, which is several orders of magnitude faster than
  # refetching from cache.nixos.org / devenv.cachix.org. Anything missing on
  # the host falls back to the upstream substituters, same as before.
  environment.etc."forgejo-runner/nix.conf".text = ''
    experimental-features = nix-command flakes
    extra-substituters = file:///mnt/host-nix-store?trusted=1
    extra-trusted-substituters = file:///mnt/host-nix-store
    substituters = https://cache.nixos.org/ https://devenv.cachix.org/
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

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
            "/etc/forgejo-runner/nix.conf"
            "/nix/store"
          ];
        };
      };
    };
  };

  # The upstream module runs as DynamicUser=yes and auto-adds the `docker`
  # supplementary group when a `:docker:` label is present and
  # virtualisation.docker is enabled — no extra user/group plumbing needed.
}
