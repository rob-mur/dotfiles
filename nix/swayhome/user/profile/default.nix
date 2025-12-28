{ ... }: let

  system = import ./system.nix {};
  profile_1 = import ./profile_1.nix {};

in

system // profile_1
