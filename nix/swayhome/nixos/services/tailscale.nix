{ ... }: let

  profile = import ./../../user/profile {};

in {
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = "both";
        };
  };
}
