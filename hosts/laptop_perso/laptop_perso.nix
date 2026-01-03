{config, ...}: {
  imports = [../../configuration.nix];

  config.machineType = "laptop_perso";

  # machine specific hardware information
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/385f5d9a-cf1f-4a78-bbbd-e17414c72167";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6645-1B92";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/214a241c-ab3d-4115-bb9d-494b1fa38ae7";}
  ];
}
