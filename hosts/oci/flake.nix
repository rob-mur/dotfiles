{
  description = "Headless command-and-control box on an OCI Ampere A1 (Always Free, aarch64)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    overlay-unstable = final: prev: {
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    # Same config for first install (nixos-anywhere) and every rebuild after:
    # disko's module only declares fileSystems from disk-config.nix, it never
    # touches the disk outside of the nixos-anywhere run.
    nixosConfigurations.dev = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = [overlay-unstable];}
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ./oci.nix
      ];
    };
  };
}
