{
  pkgs,
  config,
  ...
}: let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        waybar = {
          enable = true;
          settings = {
            mainBar = {
              layer = "bottom";
              position = "top";
              height = 18;
              spacing = 0;
              output = [
                "*"
              ];
              modules-left = [
                "pulseaudio"
                "cpu"
                "memory"
                "sway/workspaces"
                "sway/mode"
              ];
              modules-center = [
                "clock"
              ];
              modules-right = [
                "network"
                "bluetooth"
                "backlight"
                "battery"
                "tray"
              ];
              "keyboard-state" = {
                numlock = true;
                capslock = true;
                format = "{name} {icon}";
                format-icons = {
                  locked = "";
                  unlocked = "";
                };
              };
              "sway/mode" = {
                format = "<span style=\"italic\">{}</span>";
              };
              "sway/workspaces" = {
                on-click = "activate";
                sort-by-number = true;
                format = "{value}";
              };
              "sway/scratchpad" = {
                format = "{icon} {count}";
                show-empty = false;
                format-icons = [
                  ""
                  ""
                ];
                tooltip = true;
                tooltip-format = "{app}: {title}";
              };
              "sway/window" = {
                max-length = 30;
              };
              "bluetooth" = {
                format = "{status} ";
                format-disabled = "";
                format-connected = "{num_connections} pair ";
                tooltip-format = "{controller_alias}\t{controller_address}";
                tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
                tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              };
              "mpd" = {
                format = "{stateIcon} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
                format-disconnected = "off ";
                format-stopped = "{randomIcon} pause ";
                unknown-tag = "n/a";
                interval = 2;
                consume-icons = {
                  "on" = " ";
                };
                random-icons = {
                  off = "<span color=\"#f53c3c\"></span> ";
                  on = " ";
                };
                repeat-icons = {
                  on = "";
                };
                single-icons = {
                  on = " ";
                };
                state-icons = {
                  paused = "";
                  playing = "";
                };
                tooltip-format = "mpd (connected)";
                tooltip-format-disconnected = "mpd (disconnected)";
              };
              "tray" = {
                icon-size = 13;
                spacing = 8;
              };
              "clock" = {
                interval = 60;
                tooltip = false;
                format = "{:%R | %a, %d/%m/%y}";
              };
              "cpu" = {
                format = "{usage}% ";
                tooltip = false;
              };
              "memory" = {
                format = "{}% ";
              };
              "temperature" = {
                # thermal-zone" = 2;
                # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
                critical-threshold = 80;
                format-critical = "{temperatureC}°C {icon}";
                format = "{temperatureC}°C {icon}";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                ];
              };
              "backlight" = {
                # device = "acpi_video1";
                format = "{percent}% {icon}";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
              "battery" = {
                states = {
                  critical = 10;
                  warning = 20;
                  good = 90;
                  full = 100;
                  over = 101;
                };
                interval = 2;
                format = "{capacity}% {icon}";
                format-charging = "{capacity}% {icon} ";
                format-plugged = "{capacity}% {icon} ";
                format-alt = "{time} {icon}";
                # "format-good": ""; # An empty format will hide the module
                # "format-full": "";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
              "network" = {
                # "interface" = "wlp2*"; # (Optional) To force the use of this interface
                format-wifi = "{bandwidthDownBytes}   {bandwidthUpBytes}   {signalStrength}% ";
                format-ethernet = "{bandwidthDownBytes}   {bandwidthUpBytes}   {ipaddr}/{cidr} ";
                # format-wifi = "{bandwidthDownBytes}  {bandwidthUpBytes}  {signalStrength}% ";
                # format-ethernet = "{bandwidthDownBytes}  {bandwidthUpBytes}  {ipaddr}/{cidr} ";
                tooltip-format = "{ifname} via {gwaddr} ";
                format-linked = "{ifname} (no ip) ";
                format-disconnected = "off ";
                format-alt = "{ifname} = {ipaddr}/{cidr} ";
                interval = 2;
              };
              "pulseaudio" = {
                # "scroll-step" = 1; # %; can be a float
                format = "{volume}% {icon} {format_source}";
                format-bluetooth = "{volume}% {icon}  {format_source}";
                format-bluetooth-muted = " {icon}  {format_source}";
                format-muted = "{volume}%  {format_source}";
                format-source = "{volume}% ";
                format-source-muted = "{volume}% ";
                format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
              };
            };
          };
          style = ''
            * {
              font-family: ${theme.font}, ${theme.font-symbol};
              font-size: ${toString theme.font-size-alt}px;
            }

            window#waybar {
              color: ${color.r_foreground};
              background-color: ${color.r_background};
              border-bottom: 0px solid ${color.r_bright_blue};
              transition-property: background-color;
              transition-duration: .5s;
            }

            window#waybar.hidden {
              opacity: 0.2;
            }

            /*
            window#waybar.empty {
              background-color: transparent;
            }
            window#waybar.solo {
              background-color: ${color.r_bright_blue};
            }
            */

            window#waybar.termite {
              background-color: ${color.r_bright_blue};
            }

            window#waybar.chromium {
              background-color: ${color.r_bright_blue};
              border: none;
            }

            button {
              box-shadow: inset 0 0px transparent;
              border: none;
              border-radius: 0;
            }

            button:hover {
              background: inherit;
              box-shadow: inset 0 0px ${color.r_foreground};
            }

            #workspaces button {
              padding: 0 15px;
              background-color: transparent;
            }

            #workspaces button:hover {
              background: rgba(0, 0, 0, 0.2);
            }

            #workspaces button.focused {
              background-color: ${color.r_bright_blue};
              box-shadow: inset 0 0px ${color.r_foreground};
            }

            #workspaces button.urgent {
              background-color: ${color.r_bright_red};
            }

            #backlight,
            #battery,
            #bluetooth,
            #clock,
            #cpu,
            #disk,
            #memory,
            #mode,
            #mpd,
            #network,
            #pulseaudio,
            #temperature,
            #tray,

            #window,
            #workspaces {
              margin: 0 8px;
            }

            .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
            }

            .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
            }

            #backlight {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_purple};
            }

            @keyframes blink {
              to {
                color: ${color.r_foreground};
                background-color: transparent;
                border-bottom: 0px solid ${color.r_bright_green};
              }
            }

            #battery {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #battery.critical.discharging {
              animation: blink 1s infinite;
              background-color: ${color.r_bright_red};
            }

            #battery.warning.discharging {
              animation: blink 1s infinite;
              background-color: ${color.r_bright_yellow};
            }

            #battery.good {
              animation: none;
              background-color: transparent;
            }

            #battery.full.charging {
              animation: blink 1s infinite;
              background-color: ${color.r_bright_yellow};
            }

            #battery.over.charging {
              animation: blink 1s infinite;
              background-color: ${color.r_bright_red};
            }

            #bluetooth {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_yellow};
            }

            #clock {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            label:focus {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_blue};
            }

            #cpu {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_purple};
            }

            #disk {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #memory {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_yellow};
            }

            #mode {
              color: ${color.r_foreground};
              background-color: ${color.r_bright_blue};
              border-bottom: 0px solid ${color.r_foreground};
            }

            #mpd {
              background-color: transparent;
            }

            #mpd.disconnected {
              background-color: transparent;
            }

            #mpd.stopped {
              background-color: transparent;
            }

            #mpd.paused {
              background-color: transparent;
            }

            #network {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #network.disconnected {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #pulseaudio {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #pulseaudio.muted {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #temperature {
              color: ${color.r_foreground};
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_green};
            }

            #temperature.critical {
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_red};
            }

            #tray {
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_blue};
            }

            #tray > .passive {
              -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: transparent;
              border-bottom: 0px solid ${color.r_bright_blue};
            }

          '';
        };
      };
    };
  };
}
