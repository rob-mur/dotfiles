{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      timeout = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };

    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" "kvm-intel" "nouveau"];
  };
}
