{
  description = "Workstation setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    yuzu-nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    yuzu-nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlay-yuzu = final: prev: {
      yuzu-pkgs = import yuzu-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations.dev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = [overlay-yuzu];
        })

        ./desktop.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
