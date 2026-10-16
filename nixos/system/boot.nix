{
  config,
  pkgs,
  ...
}: {
  boot = {
    # Allow every SysRq key, so Alt+SysRq+F runs the kernel OOM killer when
    # the desktop locks up under memory pressure.
    kernel.sysctl."kernel.sysrq" = 1;

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

    initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    kernelParams = ["nvidia_drm.fbdev=1"];
    kernelModules = [
      "kvm-amd"
      "kvm-intel"
      "iptable_nat"
      "br_netfilter"
    ];
  };
}
