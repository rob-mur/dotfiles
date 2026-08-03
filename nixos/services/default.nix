{...}: {
  imports = [
    ./sunshine.nix
    ./gvfs.nix
    ./kdeconnect.nix
    ./tailscale.nix
    ./dbus.nix
    ./displaymanager.nix
    ./dnscrypt.nix
    ./earlyoom.nix
    ./fstrim.nix
    ./gnome-keyring.nix
    ./libinput.nix
    ./openssh.nix
    ./pcscd.nix
    ./pulseaudio.nix
    ./power-profiles.nix
    ./printing.nix
    ./timesyncd.nix
    ./udev.nix
    ./udisks2.nix
    ./upower.nix
    ./xserver.nix
  ];
}
