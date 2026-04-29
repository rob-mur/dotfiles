{config, ...}: let
in {
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = ["--ssh"];
    };
  };
}
