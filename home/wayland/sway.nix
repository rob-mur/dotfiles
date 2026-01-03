{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with pkgs; let
  color = import ./../../user/color {};

  theme = import ./../../user/theme {};

  mod4 = "Mod4";
  output = "eDP-1";
  opacity = "0.95";

  # Navigation
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  window_bg_color = color.h_background;
  view_bg_color = color.h_bright_black;
  view_fg_color = color.h_foreground;
  accent_bg_color = color.h_bright_blue;
  accent_fg_color = color.h_foreground;
  urgent_bg_color = color.h_bright_red;
  urgent_fg_color = color.h_foreground;

  # Printscreen
  shot = "${grim}/bin/grim";
  screenrec = "wl-screenrec";
  recorder = "${wl-screenrec}/bin/${screenrec}";
  area = "$(${slurp}/bin/slurp -d)";
  current = ''$(${sway}/bin/swaymsg -t get_tree | ${jq}/bin/jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${slurp}/bin/slurp -d)'';
  opt = "--low-power=off";
  filename = "$(${coreutils-full}/bin/date +%Y%m%d_%Hh%Mm%Ss_@${config.name}";
  pfilename = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshot/${filename}.png)";
  vfilename = "$(${xdg-user-dirs}/bin/xdg-user-dir VIDEOS)/recording/${filename}.mp4)";
in {
  home-manager = {
    users.${config.name} = {
      home.packages = [
        wl-kbptr # for using the mouse with the keyboard
      ];
      wayland = {
        windowManager = {
          sway = {
            enable = true;
            extraOptions = ["--unsupported-gpu"];
            config = {
              modifier = "${mod4}";
              bars = [
                {
                  command = "${waybar}/bin/waybar";
                }
              ];
              focus = {
                forceWrapping = false;
                followMouse = false;
              };
              fonts = {
                names = ["${theme.font}"];
                size = toString theme.font-size;
              };
              gaps = {
                inner = 15;
              };
              startup = [
                {command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway";}
                {command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";}

                # Initialize the keyring daemon and the Polkit agent
                {command = "gnome-keyring-daemon --start --components=secrets";}
                {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}

                # --- Portal & UI ---
                {command = "systemctl --user restart xdg-desktop-portal";}
                {command = "pkill waybar && waybar";}

                # --- Apps ---
                {command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";}
                {command = "${kitty}/bin/kitty";}
                {command = "${waytrogen}/bin/waytrogen --restore";}
              ];
              input = {
                "type:touchpad" = {
                  dwt = "enabled";
                  tap = "enabled";
                  natural_scroll = "enabled";
                  middle_emulation = "enabled";
                };

                "type:pointer" = {
                  natural_scroll = "enabled";
                };

                "type:mouse" = {
                  natural_scroll = "disabled";
                };
              };
              window = {
                border = 1;
                titlebar = false;
                commands = [
                  {
                    command = "opacity ${opacity}, border pixel 1, inhibit_idle fullscreen";
                    criteria = {
                      class = ".*";
                    };
                  }
                  {
                    command = "opacity ${opacity}, border pixel 1, inhibit_idle fullscreen";
                    criteria = {
                      app_id = ".*";
                    };
                  }
                  {
                    command = "floating enable, resize set 800 500";
                    criteria = {
                      app_id = "org.keepassxc.KeePassXC";
                    };
                  }
                  {
                    command = "resize set 650 450";
                    criteria = {
                      app_id = "snippetexpandergui";
                    };
                  }
                  {
                    command = "floating enable, sticky enable";
                    criteria = {
                      title = "Picture-in-Picture";
                    };
                  }
                  {
                    command = "floating enable, sticky enable";
                    criteria = {
                      title = ".*Sharing Indicator.*";
                    };
                  }
                  {
                    command = "floating enable, sticky enable, resize set 650 450";
                    criteria = {
                      title = ".*Syncthing Tray.*";
                    };
                  }
                ];
              };
              assigns = {
                "1" = [
                  # Terminal
                  {app_id = "foot";}
                  {app_id = "kitty";}
                  {app_id = "Alacritty";}
                ];
                "2" = [
                  # Browser
                  {app_id = ".*qutebrowser";}
                  {app_id = "firefox";}
                  {app_id = "thunderbird";}
                ];
                "3" = [
                  # Editor
                  {app_id = "vscode";}
                  {app_id = ".*zed.*";}
                  {instance = "vscodium";}
                ];
                "4" = [
                  # Editor
                  {app_id = ".*biolab.*";}
                  {app_id = "spyder";}
                ];
                "5" = [
                  # Datalabs
                  {app_id = "DBeaver";}
                  {app_id = "sqlitebrowser";}
                  {instance = "rstudio";}
                ];
                "6" = [
                  # Office
                  {app_id = "texstudio";}
                  {app_id = "libreoffice-*";}
                  {class = "Zotero";}
                ];
                "7" = [
                  # Entertainment
                  {app_id = ".*telegram.*";}
                  {app_id = "Session";}
                  {app_id = "vesktop";}
                  {class = "DeltaChat";}
                  {class = "discord";}
                ];
                "8" = [
                  # Design
                  {app_id = "inkscape";}
                  {app_id = "gimp*";}
                  {app_id = "scribus";}
                  {class = "krita";}
                ];
                "9" = [
                  # Animation
                  {app_id = "blender";}
                  {app_id = "synfigstudio";}
                ];
                "10" = [
                  # Multimedia
                  {app_id = ".*kdenlive";}
                  {app_id = "lmms";}
                  {app_id = "media-downloader";}
                  {app_id = "tenacity";}
                  {instance = "audacity";}
                ];
              };
              floating = {
                modifier = "${mod4}";
                border = 1;
                titlebar = false;
                criteria = [
                  {app_id = ".*blueman-manager-wrapped";}
                  {app_id = ".*scrcpy-wrapped";}
                  {app_id = ".*themechanger.*";}
                  {app_id = ".*wl_mirror";}
                  {app_id = ".*zathura";}
                  {app_id = ".*Waytrogen";}
                  {app_id = "imv";}
                  {app_id = "inkview";}
                  {app_id = "kvantummanager";}
                  {app_id = "mpv";}
                  {app_id = "qt5ct";}
                  {app_id = "qt6ct";}
                  {app_id = "sioyek";}
                  {app_id = "snippetexpandergui";}
                  {app_id = "system-config-printer";}
                  {app_id = "wdisplays";}
                  {app_id = "xdg-desktop-portal-gtk";}
                  {class = "Zotero";}
                  {instance = "lxappearance";}
                ];
              };
              keybindings = mkOptionDefault {
                # Rofi: menu
                "${mod4}+d" = "exec ${rofi}/bin/rofi -show drun";
                # Rofi: bluetooth
                "${mod4}+y" = "exec ${rofi-bluetooth}/bin/rofi-bluetooth";
                # Rofi: clipboard manager
                "${mod4}+c" = "exec ${cliphist}/bin/cliphist list | ${rofi}/bin/rofi -dmenu | ${cliphist}/bin/cliphist decode | ${wl-clipboard}/bin/wl-copy";
                # Rofi: password store
                "${mod4}+e" = "exec ${rofi-pass-wayland}/bin/rofi-pass";
                # Rofi: power menu
                "${mod4}+x" = "exec ${rofi}/bin/rofi -show menu -modi 'menu:${rofi-power-menu}/bin/rofi-power-menu --no-symbols'";
                # Rofi: filebrowser
                "${mod4}+g" = "exec ${rofi}/bin/rofi -show filebrowser";
                # Rofi: emoji
                "${mod4}+m" = "exec ${bemoji}/bin/bemoji";
                # Pick color
                "${mod4}+n" = "exec ${wl-color-picker}/bin/wl-color-picker clipboard";
                # Mirror screen
                "${mod4}+o" = "exec ${wl-mirror}/bin/wl-present mirror";

                # Terminal
                "${mod4}+Return" = "exec ${kitty}/bin/kitty";

                # Network utility
                "${mod4}+Shift+w" = "exec ${kitty}/bin/kitty --class floating_shell -e nmtui";

                # Modes
                "${mod4}+p" = "mode randr";
                "${mod4}+r" = "mode resize";
                "${mod4}+u" = "mode audio";
                "Print" = "mode printscreen";
                "Shift+Print" = "mode recording";

                "${mod4}+b" = "exec ${wl-kbptr}/bin/wl-kbptr -o 'modes=floating,click' -o 'mode_floating.source=detect'";
                "${mod4}+Shift+b" = "mode mouse";

                "${mod4}+bracketright" = "workspace next";
                "${mod4}+bracketleft" = "workspace prev";
                "${mod4}+period" = "workspace next";
                "${mod4}+comma" = "workspace prev";
                "${mod4}+Tab" = "workspace next";
                "${mod4}+Shift+Tab" = "workspace prev";

                "${mod4}+1" = "workspace number 1";
                "${mod4}+2" = "workspace number 2";
                "${mod4}+3" = "workspace number 3";
                "${mod4}+4" = "workspace number 4";
                "${mod4}+5" = "workspace number 5";
                "${mod4}+6" = "workspace number 6";
                "${mod4}+7" = "workspace number 7";
                "${mod4}+8" = "workspace number 8";
                "${mod4}+9" = "workspace number 9";

                "${mod4}+Shift+period" = "move container to workspace next; workspace next";
                "${mod4}+Shift+comma" = "move container to workspace prev; workspace prev";

                "${mod4}+Shift+1" = "move container to workspace number 1";
                "${mod4}+Shift+2" = "move container to workspace number 2";
                "${mod4}+Shift+3" = "move container to workspace number 3";
                "${mod4}+Shift+4" = "move container to workspace number 4";
                "${mod4}+Shift+5" = "move container to workspace number 5";
                "${mod4}+Shift+6" = "move container to workspace number 6";
                "${mod4}+Shift+7" = "move container to workspace number 7";
                "${mod4}+Shift+8" = "move container to workspace number 8";
                "${mod4}+Shift+9" = "move container to workspace number 9";

                "${mod4}+${left}" = "focus left";
                "${mod4}+${down}" = "focus down";
                "${mod4}+${up}" = "focus up";
                "${mod4}+${right}" = "focus right";

                "${mod4}+Ctrl+${left}" = "move workspace to output left";
                "${mod4}+Ctrl+${down}" = "move workspace to output down";
                "${mod4}+Ctrl+${up}" = "move workspace to output up";
                "${mod4}+Ctrl+${right}" = "move workspace to output right";

                "${mod4}+Shift+${left}" = "move left";
                "${mod4}+Shift+${down}" = "move down";
                "${mod4}+Shift+${up}" = "move up";
                "${mod4}+Shift+${right}" = "move right";

                # Audio control
                "XF86AudioRaiseVolume" = "exec ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +2%";
                "XF86AudioLowerVolume" = "exec ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -2%";
                "XF86AudioMute" = "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
                # Mic control
                "${mod4}+XF86AudioRaiseVolume" = "exec ${pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +2%";
                "${mod4}+XF86AudioLowerVolume" = "exec ${pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -2%";
                "${mod4}+XF86AudioMute" = "exec ${pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

                # Player control
                "XF86AudioPlay" = "exec ${playerctl}/bin/playerctl play-pause --player=%any,mpv,mpd";
                "XF86AudioPrev" = "exec ${playerctl}/bin/playerctl previous --player=%any,mpv,mpd";
                "XF86AudioNext" = "exec ${playerctl}/bin/playerctl next --player=%any,mpv,mpd";
                "XF86AudioStop" = "exec ${playerctl}/bin/playerctl play-pause --player=%any,mpv,mpd";

                # Brightness
                "XF86MonBrightnessUp" = "exec ${light}/bin/light -A 2";
                "XF86MonBrightnessDown" = "exec ${light}/bin/light -U 2";
              };
              colors = {
                background = window_bg_color;
                focused = {
                  border = accent_bg_color;
                  background = accent_bg_color;
                  text = accent_fg_color;
                  indicator = accent_bg_color;
                  childBorder = accent_bg_color;
                };
                focusedInactive = {
                  border = view_bg_color;
                  background = view_bg_color;
                  text = view_fg_color;
                  indicator = view_bg_color;
                  childBorder = view_bg_color;
                };
                unfocused = {
                  border = view_bg_color;
                  background = view_bg_color;
                  text = view_fg_color;
                  indicator = view_bg_color;
                  childBorder = view_bg_color;
                };
                urgent = {
                  border = urgent_bg_color;
                  background = urgent_bg_color;
                  text = urgent_fg_color;
                  indicator = urgent_bg_color;
                  childBorder = urgent_bg_color;
                };
                placeholder = {
                  border = accent_bg_color;
                  background = accent_bg_color;
                  text = accent_fg_color;
                  indicator = accent_bg_color;
                  childBorder = accent_bg_color;
                };
              };
              modes = {
                audio = {
                  # Audio = "launch: [i]input [o]output";
                  Escape = "mode default";
                  Return = "mode default";
                  "i" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select source, mode default";
                  "o" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select sink, mode default";
                };
                mouse = {
                  Escape = "mode default";
                  Return = "mode default";
                  "a" = "mode default, exec '${wl-kbptr}/bin/wl-kbptr; swaymsg mode mouse'";
                  "Shift+a" = "mode default, exec '${wl-kbptr}/bin/wl-kbptr; swaymsg mode mouse'";
                  # Mouse move
                  "h" = "seat seat0 cursor move -10 0";
                  "j" = "seat seat0 cursor move 0 10";
                  "k" = "seat seat0 cursor move 0 -10";
                  "l" = "seat seat0 cursor move 10 0";
                  # Left button
                  "s" = "seat seat0 cursor press button1";
                  "--release s" = "seat seat0 cursor release button1";
                  # Middle button
                  "d" = "seat seat0 cursor press button2";
                  "--release d" = "seat seat0 cursor release button2";
                  # Right button
                  "f" = "seat seat0 cursor press button3";
                  "--release f" = "seat seat0 cursor release button3";
                };
                printscreen = {
                  # Printscreen = "launch: [1]save-fullarea [2]save-area [3]save-current";
                  Escape = "mode default";
                  Return = "mode default";
                  "1" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${shot} "${pfilename}" | ${wl-clipboard}/bin/wl-copy -t image/png && ${notify-desktop}/bin/notify-desktop "Printscreen" "Screenshot taken...", mode default'';
                  "2" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${shot} -g "${area}" "${pfilename}" | ${wl-clipboard}/bin/wl-copy -t image/png && ${notify-desktop}/bin/notify-desktop "Printscreen" "Screenshot taken...", mode default'';
                  "3" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${shot} -g "${current}" "${pfilename}" | ${wl-clipboard}/bin/wl-copy -t image/png && ${notify-desktop}/bin/notify-desktop "Printscreen" "Screenshot taken...", mode default'';
                };
                randr = {
                  Escape = "mode default";
                  Return = "mode default";
                  # 1024x768
                  "1" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1024x768 --transform 90, mode default";
                  "2" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1024x768 --transform normal, mode default";
                  "3" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1024x768 --transform 270, mode default";
                  # 1366x768
                  "4" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1366x768 --transform 90, mode default";
                  "5" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1366x768 --transform normal, mode default";
                  "6" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1366x768 --transform 270, mode default";
                  # 1920x1080
                  "7" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1920x1080 --transform 90, mode default";
                  "8" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1920x1080 --transform normal, mode default";
                  "9" = "exec ${wlr-randr}/bin/wlr-randr --output ${output} --mode 1920x1080 --transform 270, mode default";
                };
                recording = {
                  # Recording = "launch:
                  # [1]full-with-audio [2]area-with-audio ;
                  # [3]full-without-audio [4]area-without-audio ;
                  # [0]stop-record";
                  Escape = "mode default";
                  Return = "mode default";
                  "1" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${recorder} ${opt} --filename="${vfilename}" --audio , mode default'';
                  "2" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${recorder} ${opt} --filename="${vfilename}" --geometry "$(${slurp}/bin/slurp -d)" --audio , mode default'';
                  "3" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${recorder} ${opt} --filename="${vfilename}" , mode default'';
                  "4" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${recorder} ${opt} --filename="${vfilename}" --geometry "$(${slurp}/bin/slurp -d)" , mode default'';
                  "0" = ''exec ${coreutils-full}/bin/sleep 1.0 && ${procps}/bin/pkill --signal INT ${screenrec} && ${notify-desktop}/bin/notify-desktop "Video record" "Recording stopped...", mode default'';
                };
                resize = {
                  Escape = "mode default";
                  Return = "mode default";
                  "${down}" = "resize grow height 5 px or 5 ppt";
                  "${left}" = "resize shrink width 5 px or 5 ppt";
                  "${right}" = "resize grow width 5 px or 5 ppt";
                  "${up}" = "resize shrink height 5 px or 5 ppt";
                };
                session = {
                  # Session = launch:
                  # [h]ibernate [p]oweroff [r]eboot
                  # [s]uspend [l]ockscreen log[o]ut
                  Escape = "mode default";
                  Return = "mode default";
                  "h" = "exec ${systemd}/bin/systemctl hibernate, mode default";
                  "p" = "exec ${systemd}/bin/systemctl poweroff, mode default";
                  "r" = "exec ${systemd}/bin/systemctl reboot, mode default";
                  "s" = "exec ${systemd}/bin/systemctl suspend, mode default";
                  "l" = "exec ${swaylock}/bin/swaylock, mode default";
                  "o" = "exec ${sway}/bin/swaymsg exit, mode default";
                };
              };
            };
          };
        };
      };
    };
  };
}
