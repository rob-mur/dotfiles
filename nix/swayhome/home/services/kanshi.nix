{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        kanshi = {
          enable = true;
          settings = [
            {
              profile = {
                name = "laptop";
                outputs = [
                  {
                    adaptiveSync = true;
                    criteria = "eDP-1";
                    mode = "1366x768@60.00Hz";
                    position = "0,0";
                    scale = 1.0;
                    status = "enable";
                    transform = "normal";
                  }
                ];
              };
            }
            {
              profile = {
                name = "workstation";
                outputs = [
                  {
                    adaptiveSync = true;
                    criteria = "eDP-1";
                    mode = "1366x768@60.00Hz";
                    position = "0,0";
                    scale = 1.0;
                    status = "enable";
                    transform = "normal";
                  }
                  {
                    adaptiveSync = true;
                    criteria = "HDMI-A-1";
                    mode = "1366x768@60.00Hz";
                    position = "0,0";
                    scale = 1.0;
                    status = "enable";
                    transform = "normal";
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
