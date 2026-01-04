{pkgs, lib, config, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
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
  };

  environment.pathsToLink = ["/share/wireplumber"];
  environment.systemPackages = with pkgs; [
    wireplumber
    pipewire
  ];
}
