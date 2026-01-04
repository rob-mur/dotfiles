{config, ...}: let
  res = "hd"; # hd/fhd
  wallpaper = "${./../../asset/wallpaper/${res}}";
in {
  services = {
        wpaperd = {
          enable = false;
          settings = {
            default = {
              duration = "2m";
              path = "${wallpaper}";
              sorting = "ascending";
              apply-shadow = false;
        };
      };
    };
  };
}
