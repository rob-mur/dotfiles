{
  lib,
  modulesPath,
  ...
}: {
  # OCI Ampere A1 flex shape: a KVM guest on UEFI firmware, boot volume
  # attached as paravirtualized virtio-scsi (/dev/sda), virtio NIC.
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.initrd.availableKernelModules = ["virtio_pci" "virtio_scsi" "xhci_pci" "usbhid"];

  # Installed to the removable-media path (EFI/BOOT/BOOTAA64.EFI) rather than
  # registered in NVRAM, so boot doesn't depend on OCI persisting EFI vars.
  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  # ttyAMA0 is what OCI's "Console connection" (serial console) attaches to.
  # It's the only way in if SSH and Tailscale are both broken, so keep it last
  # (the last console= gets /dev/console).
  boot.kernelParams = ["console=tty1" "console=ttyAMA0,115200"];

  # DHCP hands out the VNIC's private IP, gateway and 9000 MTU. The public IP
  # is NAT'd by OCI and never appears on the interface.
  networking.useDHCP = lib.mkDefault true;
}
