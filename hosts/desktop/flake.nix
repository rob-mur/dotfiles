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
    nixosConfigurations.dev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = [overlay-yuzu overlay-gtk-portal overlay-hypr-remote];
        })

        ./desktop.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
