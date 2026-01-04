{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  services = {
    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
      ];
      xkb = {
        layout = "${config.layout}";
      };
    };
  };
}
