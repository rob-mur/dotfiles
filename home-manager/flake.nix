{
  description = "Portable development environment for Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    devModule = import ../../nix/dev-module.nix;
  in {
    homeConfigurations = {
      "rmurphy@dev" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          devModule
        ];
      };
    };

    # Expose the module so it can be used in other flakes
    homeManagerModules.dev = devModule;
  };
}
