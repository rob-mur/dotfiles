{
  pkgs,
  ...
}:
with pkgs;
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [intel-media-driver]; # iHD VAAPI driver for Alder Lake UHD 770
    };
  };

}
