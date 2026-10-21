{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  laptopScreen = "AU Optronics 0x18A7 Unknown";

  # Put odd workspaces on the first non-laptop output and even ones on the
  # laptop. The external output's connector name (DP-1, DP-2, HDMI-A-1, ...)
  # depends on the port and dock, so look it up at runtime instead of
  # hardcoding it.
  splitWorkspacesWithLaptop = pkgs.writeShellScript "kanshi-split-workspaces" ''
    laptop=eDP-1
    external=$(${pkgs.sway}/bin/swaymsg -t get_outputs -r \
      | ${pkgs.jq}/bin/jq -r --arg laptop "$laptop" \
        '[.[] | select(.active and .name != $laptop) | .name][0] // empty')
    [ -n "$external" ] || exit 0

    for ws in 1 2 3 4 5 6 7 8 9 10; do
      if [ $((ws % 2)) -eq 0 ]; then out=$laptop; else out=$external; fi
      ${pkgs.sway}/bin/swaymsg "workspace $ws output $out" >/dev/null
    done
    # Create and move workspaces in reverse order so workspace 1 ends focused
    for ws in 10 9 8 7 6 5 4 3 2 1; do
      if [ $((ws % 2)) -eq 0 ]; then out=$laptop; else out=$external; fi
      ${pkgs.sway}/bin/swaymsg "workspace $ws, move workspace to output $out" >/dev/null
    done
  '';
in {
  services = {
    kanshi = {
      enable = true;
      systemdTarget = "sway-session.target";
      settings = [
        {
          profile.name = "work_laptop";
          profile.outputs = [
            {
              adaptiveSync = true;
              criteria = laptopScreen;
              mode = "1920x1200@60.00Hz";
              position = "0,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "work_laptop_plugged_in";
          profile.outputs = [
            {
              adaptiveSync = true;
              criteria = laptopScreen;
              mode = "1920x1200@60.00Hz";
              position = "1920,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
            {
              adaptiveSync = true;
              criteria = "Dell Inc. DELL S2721QS C1Z6M43";
              mode = "3840x2160@60.00Hz";
              position = "0,0";
              scale = 2.0;
              status = "enable";
              transform = "normal";
            }
          ];
          profile.exec = [
            # Bind workspace defaults for this profile
            "swaymsg workspace 1 output DP-1"
            "swaymsg workspace 3 output DP-1"
            "swaymsg workspace 5 output DP-1"
            "swaymsg workspace 7 output DP-1"
            "swaymsg workspace 9 output DP-1"
            "swaymsg workspace 2 output eDP-1"
            "swaymsg workspace 4 output eDP-1"
            "swaymsg workspace 6 output eDP-1"
            "swaymsg workspace 8 output eDP-1"
            "swaymsg workspace 10 output eDP-1"
            # Create and move workspaces in reverse order, alternating
            "swaymsg workspace 10, move workspace to output eDP-1"
            "swaymsg workspace 9, move workspace to output DP-1"
            "swaymsg workspace 8, move workspace to output eDP-1"
            "swaymsg workspace 7, move workspace to output DP-1"
            "swaymsg workspace 6, move workspace to output eDP-1"
            "swaymsg workspace 5, move workspace to output DP-1"
            "swaymsg workspace 4, move workspace to output eDP-1"
            "swaymsg workspace 3, move workspace to output DP-1"
            "swaymsg workspace 2, move workspace to output eDP-1"
            "swaymsg workspace 1, move workspace to output DP-1"
          ];
        }
        {
          # Fallback for any single external monitor plugged into the work
          # laptop (hot desks, other docks). Listed after the Dell profile so
          # the exact match wins when it applies.
          profile.name = "work_laptop_any_external";
          profile.outputs = [
            {
              adaptiveSync = true;
              criteria = laptopScreen;
              mode = "1920x1200@60.00Hz";
              position = "0,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
            {
              criteria = "*";
              position = "1920,0";
              status = "enable";
            }
          ];
          profile.exec = ["${splitWorkspacesWithLaptop}"];
        }
        {
          profile.name = "home_laptop_plugged_in";
          profile.outputs = [
            {
              adaptiveSync = true;
              criteria = "eDP-1";
              mode = "1366x768@60.00Hz";
              position = "0,0";
              scale = 1.0;
              status = "disable";
              transform = "normal";
            }
            {
              adaptiveSync = true;
              criteria = "AOC 24G2W1G5 0x000001B0";
              mode = "1920x1080@60.00Hz";
              position = "6400,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
            {
              adaptiveSync = true;
              criteria = "Samsung Electric Company C27JG5x H4ZN301397";
              mode = "2560x1440@60.00Hz";
              position = "3840,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
          ];
          profile.exec = [
            # Bind workspace defaults for this profile
            "swaymsg workspace 1 output DP-2"
            "swaymsg workspace 3 output DP-2"
            "swaymsg workspace 5 output DP-2"
            "swaymsg workspace 7 output DP-2"
            "swaymsg workspace 9 output DP-2"
            "swaymsg workspace 2 output DP-4"
            "swaymsg workspace 4 output DP-4"
            "swaymsg workspace 6 output DP-4"
            "swaymsg workspace 8 output DP-4"
            "swaymsg workspace 10 output DP-4"
            # Create and move workspaces in reverse order, alternating
            "swaymsg workspace 10, move workspace to output DP-4"
            "swaymsg workspace 9, move workspace to output DP-2"
            "swaymsg workspace 8, move workspace to output DP-4"
            "swaymsg workspace 7, move workspace to output DP-2"
            "swaymsg workspace 6, move workspace to output DP-4"
            "swaymsg workspace 5, move workspace to output DP-2"
            "swaymsg workspace 4, move workspace to output DP-4"
            "swaymsg workspace 3, move workspace to output DP-2"
            "swaymsg workspace 2, move workspace to output DP-4"
            "swaymsg workspace 1, move workspace to output DP-2"
          ];
        }
        {
          profile.name = "workstation";
          # Samsung is cabled to both NVIDIA DP and Intel iGPU HDMI. When
          # NVIDIA drives display, suppress the iGPU HDMI-A-2 mirror so the
          # monitor isn't seen as a phantom duplicate. When iGPU is the only
          # display path, HDMI-A-2 *is* the Samsung — leave the rule out.
          profile.outputs =
            [
              {
                adaptiveSync = true;
                criteria = "AOC 24G2W1G5 0x000001B0";
                mode = "1920x1080@60.00Hz";
                position = "2560,0";
                scale = 1.0;
                status = "enable";
                transform = "normal";
              }
              {
                adaptiveSync = true;
                criteria = "Samsung Electric Company C27JG5x H4ZN301397";
                mode = "2560x1440@60.00Hz";
                position = "0,0";
                scale = 1.0;
                status = "enable";
                transform = "normal";
              }
            ]
            ++ lib.optional osConfig.nvidiaForDisplay {
              criteria = "HDMI-A-2";
              status = "disable";
            };
          profile.exec = [
            # Bind workspace defaults for this profile
            "swaymsg workspace 1 output DP-4"
            "swaymsg workspace 3 output DP-4"
            "swaymsg workspace 5 output DP-4"
            "swaymsg workspace 7 output DP-4"
            "swaymsg workspace 9 output DP-4"
            "swaymsg workspace 2 output DP-3"
            "swaymsg workspace 4 output DP-3"
            "swaymsg workspace 6 output DP-3"
            "swaymsg workspace 8 output DP-3"
            "swaymsg workspace 10 output DP-3"
            # Create and move workspaces in reverse order, alternating
            "swaymsg workspace 10, move workspace to output DP-3"
            "swaymsg workspace 9, move workspace to output DP-4"
            "swaymsg workspace 8, move workspace to output DP-3"
            "swaymsg workspace 7, move workspace to output DP-4"
            "swaymsg workspace 6, move workspace to output DP-3"
            "swaymsg workspace 5, move workspace to output DP-4"
            "swaymsg workspace 4, move workspace to output DP-3"
            "swaymsg workspace 3, move workspace to output DP-4"
            "swaymsg workspace 2, move workspace to output DP-3"
            "swaymsg workspace 1, move workspace to output DP-4"
          ];
        }
      ];
    };
  };
}
