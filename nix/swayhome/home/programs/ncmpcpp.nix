{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        ncmpcpp = {
          enable = true;
          bindings = [
            {
              key = "j";
              command = ["scroll_down"];
            }
            {
              key = "k";
              command = ["scroll_up"];
            }
            {
              key = "J";
              command = ["select_item" "scroll_down"];
            }
            {
              key = "K";
              command = ["select_item" "scroll_up"];
            }
            {
              key = "q";
              command = ["dummy"];
            }
            {
              key = "ctrl-q";
              command = ["quit"];
            }
          ];
          settings = {
            autocenter_mode = "yes";
            centered_cursor = "yes";
            external_editor = "${helix}/bin/hx";
            header_visibility = "no";
            ignore_leading_the = true;
            main_window_color = "blue";
            message_delay_time = 1;
            playlist_disable_highlight_delay = 2;
            progressbar_color = "black";
            progressbar_elapsed_color = "blue";
            progressbar_look = "━━━";
            statusbar_visibility = "no";
            titles_visibility = "no";
            user_interface = "alternative";
            visualizer_color = "blue, green";
            visualizer_data_source = "/tmp/mpd.fifo";
            visualizer_look = "●●";
            visualizer_output_name = "mpd-visualizer";
            visualizer_type = "ellipse";
          };
        };
      };
    };
  };
}
