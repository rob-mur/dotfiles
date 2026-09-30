{
  description = "Home Manager + system-manager configuration for phone (Android VM, aarch64)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Root-owned bits home-manager can't do (the setuid fusermount3 omnibin
    # needs) on a non-NixOS host. Tracks its own nixpkgs (unstable).
    system-manager.url = "github:numtide/system-manager";
    # Deliberately not following our nixpkgs: its own pin is what upstream
    # builds and caches.
    omnibin.url = "github:fzakaria/omnibin";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixpkgs-unstable,
    system-manager,
    omnibin,
    ...
  }: let
    system = "aarch64-linux";
    # claude-code.nix (shared with the other hosts) pulls the package from
    # pkgs-unstable so it tracks upstream's fast release cadence; standalone
    # home-manager has no NixOS module system to apply this as a system
    # overlay, so it's added directly to the pkgs passed into
    # homeManagerConfiguration below.
    overlay-unstable = final: prev: {
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    # Tools from the other inputs, so home modules can use them as pkgs.*.
    overlay-inputs = final: prev: {
      inherit (omnibin.packages.${system}) omnibin omnibin-shell;
      system-manager = system-manager.packages.${system}.default;
    };

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [overlay-unstable overlay-inputs];
    };

    # Root-owned bits home-manager can't do itself: the setuid fusermount3
    # omnibin-shell needs to mount the lazy store as a normal user, and a
    # direct sshd (sshd.nix). Built
    # here and handed to home-manager, whose activation applies it (see
    # system.nix), so `home-manager switch` is the only command to run.
    systemConfig = system-manager.lib.makeSystemConfig {
      modules = [
        {
          nixpkgs.hostPlatform = system;
          security.wrappers.fusermount3 = {
            source = "${pkgs.fuse3}/bin/fusermount3";
            setuid = true;
            owner = "root";
            group = "root";
          };
          # Keep droid's user systemd (the omnibin service) running with no
          # session open, e.g. when only reached over SSH.
          systemd.tmpfiles.rules = ["f /var/lib/systemd/linger/droid"];
        }
        ./sshd.nix
        # sshd.nix's users.users.sshd turns on userborn, which rewrites
        # /etc/shadow every boot and can drop the cloud-init `droid` user on a
        # hard VM kill. This self-heals droid's login before anything can lock
        # us out. See the file header for the full story.
        ./droid-login.nix
      ];
    };
  in {
    homeConfigurations."dev" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit systemConfig;};
      modules = [
        ./phone.nix
        ./system.nix
      ];
    };

    # Still exposed so `system-manager switch --flake .` works standalone.
    systemConfigs.default = systemConfig;

    # Expose home-manager / system-manager for easy running/bootstrapping
    packages.${system} = {
      home-manager = home-manager.packages.${system}.home-manager;
      system-manager = system-manager.packages.${system}.default;
    };
  };
}
