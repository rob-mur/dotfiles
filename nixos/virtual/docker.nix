{ ... }: {

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
      };
    };
  };

  hardware.nvidia-container-toolkit.enable = true;
}
