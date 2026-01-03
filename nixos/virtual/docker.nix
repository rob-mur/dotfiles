{ ... }: {
  virtualisation = {
    docker = {
      enable = false;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
      };
    };
  };
}
