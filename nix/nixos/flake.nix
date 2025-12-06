{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    oldnixpgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    oldnixpgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Your existing overlay for Yuzu
    overlay-r2305 = final: prev: {
      r2305 = import oldnixpgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    inherit (self) outputs;
  in {
    nixosConfigurations = {
      dev = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};

        modules = [
          # Apply the overlay
          ({
            config,
            pkgs,
            ...
          }: {
            nixpkgs.overlays = [overlay-r2305];
          })

          ./configuration.nix

          # Import Home Manager as a NixOS Module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
          }
        ];
      };
    };
  };
}
