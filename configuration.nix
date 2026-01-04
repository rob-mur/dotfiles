{lib, ...}: {
  imports = [
    ./options.nix
    ./nixos
    ./home/nixos.nix
  ];
}
