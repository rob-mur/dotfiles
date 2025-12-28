{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        batsignal = {
          enable = false;
          extraArgs = [
            "-c" "10"
            "-w" "30"
            "-f" "97"
          ];
        };
      };
    };
  };
}
