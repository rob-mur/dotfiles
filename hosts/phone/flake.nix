{
  description = "Home Manager configuration for phone (Android VM, aarch64)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "aarch64-linux";
  in {
    homeConfigurations."dev" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        ./phone.nix
      ];
    };

    # Expose home-manager for easy running/bootstrapping
    packages.${system}.home-manager = home-manager.packages.${system}.home-manager;
  };
}
