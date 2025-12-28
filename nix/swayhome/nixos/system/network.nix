{ ... }: let

  profile = import ./../../user/profile {};

in {
  networking = {
    hostName = "${profile.hostname}";
    networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  interfaces.wlan0.useDHCP = true;
  # TODO: only enable this when the device exists or it
  # makes a very slow start job
  # interfaces.enp4s0.wakeOnLan.enable = true;
};
}
