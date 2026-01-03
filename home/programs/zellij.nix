{config, ...}: let
  color = import ./../../user/color {};
in {
  programs = {
        zellij = {
          enable = false;
          enableFishIntegration = false;
          settings = {
            copy_command = "wl-copy";
            default_layout = "compact";
            default_shell = "fish";
            pane_frames = false;
            simplified_ui = true;
            theme = "${config.name}";
            themes = {
              ${config.name} = {
                fg = color.h_foreground;
                bg = color.h_bright_black;
                black = color.h_black;
                red = color.h_red;
                green = color.h_green;
                yellow = color.h_yellow;
                blue = color.h_blue;
                magenta = color.h_purple;
                cyan = color.h_cyan;
                white = color.h_white;
                orange = color.h_yellow;
            plugins = {
              tab-bar.path = "tab-bar";
              status-bar.path = "status-bar";
              strider.path = "strider";
              compact-bar.path = "compact-bar";
            };
            ui = {
              pane_frames = {
                hide_session_name = true;
                rounded_corners = false;
              };
            };
          };
        };
      };
    };
  };
}
