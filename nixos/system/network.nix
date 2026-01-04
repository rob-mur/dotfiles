{config, ...}: let
in {
  networking = {
    hostName = "${config.hostname}";
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
  };
}
