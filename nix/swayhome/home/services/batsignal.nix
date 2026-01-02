{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
    };
  };
}
