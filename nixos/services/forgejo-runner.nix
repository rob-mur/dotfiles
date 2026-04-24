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

  # nix.conf for job containers: points Nix at the self-hosted atticd binary
  # cache at https://attic.clarob.uk/bexcel-ci so devenv shells resolve from
  # our cache before falling back to cache.nixos.org / devenv.cachix.org.
  # Consuming workflows mount this at /etc/nix/nix.conf in the job container.
  environment.etc."forgejo-runner/nix.conf".text = ''
    experimental-features = nix-command flakes
    substituters = https://attic.clarob.uk/bexcel-ci https://cache.nixos.org/ https://devenv.cachix.org/
    trusted-public-keys = bexcel-ci:4aPozx0nwacOgGdgfhOhVVsDHme8O3LHMlI8ZCDi5IY= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
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
          ];
        };
      };
    };
  };

  # The upstream module runs as DynamicUser=yes and auto-adds the `docker`
  # supplementary group when a `:docker:` label is present and
  # virtualisation.docker is enabled — no extra user/group plumbing needed.
}
