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
    keepassxc = {
      name = "KeePassXC";
      genericName = "Password Manager";
      comment = "Securely store and manage your passwords";
      exec = "${pkgs.keepassxc}/bin/keepassxc";
      terminal = false;
      categories = ["Utility" "Security"];
      icon = "keepassxc"; # Assuming there's an icon named 'keepassxc'
    };
  };
}
