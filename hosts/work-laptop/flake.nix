{
  description = "Home Manager configuration for work laptop (Ubuntu)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixgl,
    ...
  }: let
    pkgs-unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        (import ./overlays.nix {inherit nixgl;})
      ];
    };

    overlay-unstable = final: prev: {
      pkgs-unstable = pkgs-unstable;
    };

    overlay-gtk-portal = final: prev: {
      xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (oldAttrs: {
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            # Fix UseIn to include sway, not just gnome
            sed -i 's/UseIn=gnome/UseIn=gnome;sway/' $out/share/xdg-desktop-portal/portals/gtk.portal
          '';
      });
    };
    overlay-hypr-remote = final: prev: {
      xdg-desktop-portal-hypr-remote = prev.stdenv.mkDerivation {
        pname = "xdg-desktop-portal-hypr-remote";
        version = "unstable-2025-06-09";
        src = prev.fetchFromGitHub {
          owner = "gac3k";
          repo = "xdg-desktop-portal-hypr-remote";
          rev = "f463018129c5effd3b82b477d7f84fe0d0820a6b";
          hash = "sha256-hbRlPcrPWOKWZvLlnsw37/s4P+bLRq59n+R9qtVbIXc=";
        };
        patches = [../../nixos/patches/hypr-remote-keysym.patch];
        patchFlags = ["--ignore-whitespace" "-p1" "-F3"];
        nativeBuildInputs = with prev; [cmake pkg-config wayland-scanner];
        buildInputs = with prev; [wayland.dev wayland-protocols libei sdbus-cpp libffi systemd libxkbcommon];
        cmakeFlags = ["-DCMAKE_INSTALL_LIBEXECDIR=bin" "-DCMAKE_EXE_LINKER_FLAGS=-lxkbcommon"];
      };
    };
  in {
    homeConfigurations."dev" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          (import ./overlays.nix {inherit nixgl;})
        ];
      };
      modules = [
        ({...}: {
          nixpkgs.overlays = [overlay-gtk-portal overlay-hypr-remote overlay-unstable];
        })
        ./work-laptop.nix
      ];
    };

    # Expose home-manager for easy running
    packages.x86_64-linux.home-manager = home-manager.packages.x86_64-linux.home-manager;
  };
}
