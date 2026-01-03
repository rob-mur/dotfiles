{
  pkgs,
  ...
}:
with pkgs;
{
  services = {
    udev = {
      enable = true;
      packages = [
        # via # unfree
      ];
    };
  };
}
