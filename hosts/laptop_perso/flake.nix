{
  description = "Laptop setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    yuzu-nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    unstable-nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      pkgs-unstable = import unstable-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations.dev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./laptop_perso.nix
        home-manager.nixosModules.home-manager
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = [overlay-unstable];
        })
      ];
    };
  };
}
