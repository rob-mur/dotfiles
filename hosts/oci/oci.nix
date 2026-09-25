{
  config,
  lib,
  pkgs,
  ...
}: {
  # Server-shaped subset of ../../nixos. configuration.nix is not imported:
  # it pulls in the whole desktop (sway, greetd, pipewire, nvidia, printing).
  imports = [
    ../../options.nix
    ./hardware.nix
    ./disk-config.nix

    ../../nixos/system/documentation.nix
    ../../nixos/system/locale.nix
    ../../nixos/system/nix.nix
    ../../nixos/system/systemd.nix
    ../../nixos/system/timezone.nix
    ../../nixos/system/users.nix
    ../../nixos/system/zram.nix
    ../../nixos/services/earlyoom.nix
    ../../nixos/services/fstrim.nix
    ../../nixos/services/openssh.nix
    ../../nixos/services/tailscale.nix
    ../../nixos/services/timesyncd.nix
    ../../nixos/programs/git.nix
    ../../nixos/programs/mtr.nix
    ../../nixos/virtual/docker.nix
  ];

  machineType = "oci";
  hostDir = "/home/rob/repos/dotfiles/hosts/oci/";
  hostname = "oci";
  version = "26.05";

  system.stateVersion = config.version;
  networking.hostName = config.hostname;

  # Keys allowed to log in as ${config.name}. nixos-anywhere also needs the
  # matching private key to reach the stock Ubuntu image, so use the same key
  # you gave OCI when creating the instance.
  users.users.${config.name}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJPoKG+D+RLNZ0c9qh3peXXO94+LNKNMTiVjV1C9fJl robert.murphy@DC-2D7K314"
  ];

  # Key-only login and no root SSH (openssh.nix), so there is no password to
  # type at a sudo prompt. Without this the box can't be administered at all.
  security.sudo.wheelNeedsPassword = false;

  # docker.nix is shared with the desktop, which has an NVIDIA card.
  hardware.nvidia-container-toolkit.enable = lib.mkForce false;

  # The public side only answers SSH (openssh.nix opens 22) and Tailscale's
  # WireGuard port for direct peer connections. Anything reached over the
  # tailnet (mosh, dev servers, ...) is open, since tailnet ACLs already gate it.
  services.tailscale.openFirewall = true;
  networking.firewall.trustedInterfaces = ["tailscale0"];

  # Survives flaky phone connections; only reachable via tailscale0.
  programs.mosh = {
    enable = true;
    openFirewall = false;
  };

  # Tooling for driving the other machines.
  environment.systemPackages = with pkgs; [
    age
    deploy-rs
    devenv
    gh
    nixos-anywhere
    sops
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users.${config.name} = {
      # minimal.nix reads name/version from its own module config (it's written
      # for standalone home-manager), so hand it the NixOS values.
      imports = [
        ../../options.nix
        ../../home/minimal.nix
      ];
      inherit (config) name version fullname email gitEmail hostDir machineType hostname;

      programs.neovim.defaultEditor = true;
    };
  };
}
