{lib, ...}: {
  imports = [
    ./nixos
    ./home
  ];

  options = {
    machineType = lib.mkOption {
      type = lib.types.enum ["desktop" "laptop_perso"];
      default = "desktop";
      description = "Machine profile to use";
    };

    name = lib.mkOption {
      type = lib.types.str;
      default = "rob";
      description = "Username";
    };
  };
}
