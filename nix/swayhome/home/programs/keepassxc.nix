{
  pkgs,
  config,
  ...
}: let
in {
  services.dbus.packages = [pkgs.keepassxc];
  home-manager = {
    users.${config.name} = {
      home.file.".config/vivaldi/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json" = {
        text = builtins.toJSON {
          allowed_origins = [
            "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
            "chrome-extension://pdffhmdngciaglkoonimfcmckachoopb/"
          ];
          description = "KeePassXC integration with native messaging support";
          name = "org.keepassxc.keepassxc_browser";
          path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
          type = "stdio";
        };
      };

      programs = {
        keepassxc = {
          enable = true;
          settings = {
            Browser = {
              Enabled = true;
              Vivaldi = true;
              Chrome = true;
            };
            GUI = {
              AdvancedSettings = true;
              ApplicationTheme = "classic";
              CheckForUpdates = false;
              ColorPasswords = true;
              CompactMode = true;
              HidePasswords = true;
              MinimizeOnClose = true;
              MinimizeOnStartup = true;
              MinimizeToTray = true;
              MonospaceNotes = true;
              ShowTrayIcon = true;
              TrayIconAppearance = "monochrome-light";
            };
            General = {
              ConfigVersion = 2;
              MinimizeAfterUnlock = true;
            };
            KeeShare = {
              QuietSuccess = true;
            };
            SSHAgent = {
              Enabled = true;
            };
          };
        };
      };
    };
  };
}
