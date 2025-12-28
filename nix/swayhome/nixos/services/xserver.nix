{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  services = {
    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
      ];
      xkb = {
        layout = "${profile.layout}";
      };
    };
  };
}
