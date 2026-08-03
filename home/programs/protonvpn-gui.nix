{
  pkgs,
  lib,
  config,
  osConfig ? config,
  ...
}: let
  # work-laptop runs Ubuntu's system NetworkManager (1.46); the nixpkgs proton-vpn
  # links a newer libnm and its kill-switch commit fails
  # (802-11-wireless.mac-address-denylist: unknown property). Use the official
  # Proton Ubuntu .deb there instead. Keep the nix package on NixOS hosts.
  isWorkLaptop = osConfig.machineType == "work-laptop";
in {
  home.packages = lib.optionals (!isWorkLaptop) [pkgs.proton-vpn];
}
