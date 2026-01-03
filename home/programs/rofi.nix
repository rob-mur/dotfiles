{
  pkgs,
  config,
  ...
}:
with pkgs; let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};

  externalConfig = config;
in {
  home-manager = {
    users.${config.name} = {config, ...}: {
      programs = {
        rofi = {
          enable = true;
          font = "${theme.font} ${toString theme.font-size}";
          package = rofi;
          extraConfig = {
            case-sensitive = false;
            display-drun = "Apps:";
            modi = [
              "drun"
              "filebrowser"
              "run"
            ];
            show-icons = false;
          };
          pass = {
            enable = true;
            package = rofi-pass-wayland;
            stores = ["/home/${externalConfig.name}/${externalConfig.pass}"];
          };
          plugins = [
            rofi-file-browser
            rofi-pass-wayland
            rofi-pulse-select
            rofi-systemd
          ];
          theme = let
            mkLiteral = config.lib.formats.rasi.mkLiteral;
          in {
            "*" = {
              bg = mkLiteral color.h_background;
              fg = mkLiteral color.h_foreground;
              ac = mkLiteral color.h_bright_blue;
              background-color = mkLiteral "transparent";
            };

            "#window" = {
              background-color = mkLiteral "@bg";
              location = mkLiteral "center";
              width = mkLiteral "30%";
            };

            "#prompt" = {
              text-color = mkLiteral "@fg";
            };

            "#textbox-prompt-colon" = {
              text-color = mkLiteral "@fg";
            };

            "#entry" = {
              text-color = mkLiteral "@fg";
              blink = mkLiteral "true";
            };

            "#inputbar" = {
              children = mkLiteral "[ prompt, entry ]";
              text-color = mkLiteral "@fg";
              padding = mkLiteral "5px";
            };

            "#listview" = {
              columns = mkLiteral "1";
              lines = mkLiteral "6";
              cycle = mkLiteral "true";
              dynamic = mkLiteral "true";
            };

            "#mainbox" = {
              border = mkLiteral "1px";
              border-color = mkLiteral "@ac";
              children = mkLiteral "[ inputbar, listview ]";
              padding = mkLiteral "10px";
            };

            "#element" = {
              text-color = mkLiteral "@fg";
              padding = mkLiteral "5px";
            };

            "#element-icon" = {
              text-color = mkLiteral "@fg";
              size = mkLiteral "32px";
            };

            "#element-text" = {
              text-color = mkLiteral "@fg";
              padding = mkLiteral "5px";
            };

            "#element selected" = {
              border = mkLiteral "1px";
              border-color = mkLiteral "@ac";
              text-color = mkLiteral "@fg";
              background-color = mkLiteral "@ac";
            };
          };
        };
      };
    };
  };
}
