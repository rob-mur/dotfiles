{config, ...}: let
in {
  services = {
        batsignal = {
          enable = false;
          extraArgs = [
            "-c"
            "10"
            "-w"
            "30"
            "-f"
            "97"
          ];
    };
  };
}
