{pkgs, ...}: {
  services = {
    pipewire.enable = false;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-dbus-protocol
        load-module module-native-protocol-unix
      '';
    };
  };
}
