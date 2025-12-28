{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        zed-editor = {
          enable = false;
          extensions = [
            "cairo"
            "cython"
            "dart"
            "deno"
            "dockerfile"
            "ejs"
            "elixir"
            "erlang"
            "fish"
            "gdscript"
            "golangci-lint"
            "haskell"
            "java"
            "julia"
            "kotlin"
            "latex"
            "live-server"
            "ltex"
            "lua"
            "marksman"
            "meson"
            "nix"
            "odin"
            "r"
            "rust"
            "scala"
            "scss"
            "solidity"
            "sql"
            "typst"
            "zed"
            "zig"
          ];
          userSettings = {
            autosave = "off";
            auto_update = "off";
            buffer_font_size = 14;
            git = {
              git_gutter = "tracked_files";
              inline_blame = {
                enabled = false;
              };
            };
            scrollbar = {
              cursors = true;
              diagnostics = true;
              git_diff = true;
              search_results = true;
              selected_symbol = true;
              show = "auto";
            };
            show_copilot_suggestions = false;
            tabs = {
              close_position = "right";
              git_status = true;
            };
            theme = "Ayu Dark";
            telemetry = {
              diagnostics = false;
              metrics = false;
            };
            ui_font_size = 14;
            vim_mode = true;
          };
        };
      };
    };
  };
}
