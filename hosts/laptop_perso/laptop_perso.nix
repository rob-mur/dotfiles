{
  config,
  lib,
  ...
}: {
  imports = [../../configuration.nix];

  machineType = "laptop_perso";
  hostDir = "/home/robm/repos/dotfiles/hosts/laptop_perso/";
  name = "robm";
  autoTimezone = true; # detect timezone from location (this laptop travels)

  # machine specific hardware information
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/385f5d9a-cf1f-4a78-bbbd-e17414c72167";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6645-1B92";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  # Second NVMe (KIOXIA KXG60ZNV512G, serial Z9OA71B6K81L). Was the other half
  # of a Windows Intel RST RAID-0 volume; reformatted as a dedicated /home.
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/884f6233-b5e7-4468-a460-aec51b3b85c7";
    fsType = "ext4";
    options = ["defaults" "noatime"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/214a241c-ab3d-4115-bb9d-494b1fa38ae7";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
