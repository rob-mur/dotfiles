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
    overlay-gtk-portal = final: prev: {
      xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          # Fix UseIn to include sway, not just gnome
          sed -i 's/UseIn=gnome/UseIn=gnome;sway/' $out/share/xdg-desktop-portal/portals/gtk.portal
        '';
      });
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
          nixpkgs.overlays = [overlay-yuzu overlay-gtk-portal];
        })

        ./desktop.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
