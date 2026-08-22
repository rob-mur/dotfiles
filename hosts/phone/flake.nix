{
  description = "Home Manager configuration for phone (Android VM, aarch64)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixpkgs-unstable,
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
  in {
    homeConfigurations."dev" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [overlay-unstable];
      };
      modules = [
        ./phone.nix
      ];
    };

    # Expose home-manager for easy running/bootstrapping
    packages.${system}.home-manager = home-manager.packages.${system}.home-manager;
  };
}
