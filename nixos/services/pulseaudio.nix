{pkgs, lib, config, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/52-xonar-surround.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                { device.name = "~alsa_card.*ASUSTeK_Xonar.*" }
              ]
              actions = {
                update-props = {
                  device.profile = "analog-surround-51"
                }
              }
            }
          ]

        '')
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-disable-batch.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  api.alsa.use-acp = true
                  api.alsa.disable-batch = true
                }
              }
            }
          ]
        '')
      ];
    };

    # Apply upmix to all PulseAudio output streams (e.g. Spotify)
    # stream.properties in pipewire-pulse.conf is the correct mechanism in PipeWire
    extraConfig.pipewire-pulse."99-upmix" = {
      "stream.properties" = {
        "channelmix.upmix" = true;
        "channelmix.upmix-method" = "psd";
      };
    };
  };

  environment.pathsToLink = ["/share/wireplumber"];
  environment.systemPackages = with pkgs; [
    wireplumber
    pipewire
  ];
}
