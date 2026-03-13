{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home.packages = [
        kdePackages.dolphin
        kdePackages.dolphin-plugins # For Git/Svn integration
        kdePackages.kdegraphics-thumbnailers # For image/PDF previews
        kdePackages.qtsvg # Required for many icons to display properly
        kdePackages.kio-extras
      ];

  # Register Dolphin as the FileManager1 D-Bus service
  # This allows Chromium-based browsers to use "Show in folder"
  home.file.".local/share/dbus-1/services/org.freedesktop.FileManager1.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.FileManager1
    Exec=${kdePackages.dolphin}/bin/dolphin --daemon
  '';
}
