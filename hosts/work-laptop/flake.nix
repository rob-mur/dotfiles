{
  description = "Home Manager configuration for work laptop (Ubuntu)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixgl,
    ...
  }: {
    homeConfigurations."dev" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          (import ./overlays.nix {inherit nixgl;})
        ];
      };
      modules = [./work-laptop.nix];
    };

    # Expose home-manager for easy running
    packages.x86_64-linux.home-manager = home-manager.packages.x86_64-linux.home-manager;
  };
}
