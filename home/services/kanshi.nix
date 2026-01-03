{config, ...}: let
in {
  services = {
        kanshi = {
          enable = true;
          settings = [
            {
              profile.name = "work_laptop";
              profile.outputs = [
                {
                  adaptiveSync = true;
                  criteria = "AU Optronics 0x18A7 Unknown";
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
                  criteria = "AU Optronics 0x18A7 Unknown";
                  mode = "1920x1200@60.00Hz";
                  position = "7860,960";
                  scale = 1.0;
                  status = "enable";
                  transform = "normal";
                }
                {
                  adaptiveSync = true;
                  criteria = "Dell Inc. DELL S2721QS C1Z6M43";
                  mode = "3840x2160@60.00Hz";
                  position = "3840,0";
                  scale = 1.0;
                  status = "enable";
                  transform = "normal";
                }
              ];
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
            }
            {
              profile.name = "workstation";
              profile.outputs = [
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
            }
          ];
    };
  };
}
