{ ... }: {
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
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
}
