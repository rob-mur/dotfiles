{ ... }: let

  profile = import ./../../user/profile {};
  res = "hd";  # hd/fhd
  wallpaper = "${./../../asset/wallpaper/${res}}";

in {
  home-manager = {
    users.${profile.name} = {
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
    };
  };
}
