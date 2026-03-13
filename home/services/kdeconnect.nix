{...}: {
  services.kdeconnect = {
    enable = true;
    indicator = false; # No system tray indicator needed in Sway
  };
}
