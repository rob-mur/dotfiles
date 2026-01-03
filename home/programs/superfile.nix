{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  programs = {
        superfile = {
          enable = true;
          settings = {
            theme = "onedark";
            editor = "${helix}/bin/hx";
            dir_editor = "";
            auto_check_update = false;
            cd_on_quit = false;
            default_open_file_preview = true;
            show_image_preview = true;
            show_panel_footer_info = true;
            default_directory = "/home/${config.name}";
            file_size_use_si = false;
            default_sort_type = 0;
            sort_order_reversed = false;
            case_sensitive_sort = true;
            shell_close_on_success = false;
            debug = true;
            ignore_missing_fields = false;
            code_previewer = "${bat}/bin/bat";
            nerdfont = true;
            transparent_background = true;
            file_preview_width = 0;
            sidebar_width = 20;
            border_top = "─";
            border_bottom = "─";
            border_left = "│";
            border_right = "│";
            border_top_left = "┌";
            border_top_right = "┐";
            border_bottom_left = "└";
            border_bottom_right = "┘";
            border_middle_left = "├";
            border_middle_right = "┤";
            metadata = false;
            zoxide = false;
            zoxide_support = false;
            enable_md5_checksum = false;
          };
          hotkeys = {
            # global hotkeys
            confirm = ["enter" "right" "l"];
            quit = ["ctrl+q"];

            # movement
            list_up = ["up" "k"];
            list_down = ["down" "j"];
            page_up = ["pgup" ""];
            page_down = ["pgdown" ""];

            # file panel control
            create_new_file_panel = ["n" ""];
            close_file_panel = ["w" ""];
            next_file_panel = ["tab" "L"];
            previous_file_panel = ["shift+left" "H"];
            toggle_file_preview_panel = ["f" ""];
            open_sort_options_menu = ["o" ""];
            toggle_reverse_sort = ["R" ""];

            # change focus
            focus_on_process_bar = ["p" ""];
            focus_on_sidebar = ["s" ""];
            focus_on_metadata = ["m" ""];

            # create file/directory and rename
            file_panel_item_create = ["ctrl+n" ""];
            file_panel_item_rename = ["ctrl+r" ""];

            # file operations
            copy_items = ["ctrl+c" ""];
            cut_items = ["ctrl+x" ""];
            paste_items = ["ctrl+v" "ctrl+w" ""];
            delete_items = ["ctrl+d" "delete" ""];

            # compress and extract
            extract_file = ["ctrl+e" ""];
            compress_file = ["ctrl+a" ""];

            # editor
            open_file_with_editor = ["e" ""];
            open_current_directory_with_editor = ["E" ""];

            # other
            pinned_directory = ["P" ""];
            toggle_dot_file = ["." ""];
            change_panel_mode = ["v" ""];
            open_help_menu = ["?" ""];
            open_command_line = [":" ""];
            open_spf_prompt = [">" ""];
            copy_path = ["ctrl+p" ""];
            copy_present_working_directory = ["c" ""];
            toggle_footer = ["F" ""];

            # typing hotkeys
            confirm_typing = ["enter" ""];
            cancel_typing = ["ctrl+c" "esc"];

            # normal mode hotkeys
            parent_directory = ["h" "left" "backspace"];
            search_bar = ["/" ""];

            # select mode hotkeys
            file_panel_select_mode_items_select_down = ["shift+down" "J"];
            file_panel_select_mode_items_select_up = ["shift+up" "K"];
            file_panel_select_all_items = ["A" ""];
      };
    };
  };
}
