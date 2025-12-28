{ ... }: {
  hardware.enableAllFirmware = true;
  boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=3" "snd_hda_intel.model=dell-headset-multi"];
  services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = false;
      };
      pulse.enable = true;

    extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 2048;
    };
    };
  };
}
