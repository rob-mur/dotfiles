{lib, ...}: {
  machineType = lib.mkOption {
    type = lib.types.enum ["desktop" "laptop_perso"];
    default = "desktop";
    description = "The type of machine this configuration is for. Controlled through hosts";
  };
}
