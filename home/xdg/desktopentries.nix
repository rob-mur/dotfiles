{pkgs, ...}: {
  xdg.desktopEntries = {
    waytrogen = {
      name = "Waytrogen";
      genericName = "Wallpaper Setter";
      comment = "GUI wallpaper setter for Wayland";
      exec = "${pkgs.waytrogen}/bin/waytrogen";
      terminal = false;
      categories = ["Graphics" "Utility"];
      icon = "preferences-desktop-wallpaper";
    };
  };
}
