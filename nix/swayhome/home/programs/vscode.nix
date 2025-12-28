{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};
  theme = import ./../../user/theme {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        vscode = {
          enable = false;
          package = vscodium;
          profiles = {
            default = {
              extensions = with vscode-extensions; [
                bbenoist.nix
                elixir-lsp.vscode-elixir-ls
                esbenp.prettier-vscode
                golang.go
                julialang.language-julia
                llvm-vs-code-extensions.vscode-clangd
                ms-pyright.pyright
                ms-python.isort
                ms-python.python
                ms-toolsai.datawrangler
                ms-toolsai.jupyter
                ms-toolsai.jupyter-keymap
                ms-toolsai.jupyter-renderers
                ms-toolsai.vscode-jupyter-cell-tags
                ms-toolsai.vscode-jupyter-slideshow
                naumovs.color-highlight
                reditorsupport.r
                rust-lang.rust-analyzer
                scala-lang.scala
                scalameta.metals
                shardulm94.trailing-spaces
                sumneko.lua
                vscodevim.vim
                xaver.clang-format
              ];
              userSettings = {
                "diffEditor.ignoreTrimWhitespace" = false;
                "editor.codeLens" = false;
                "editor.find.cursorMoveOnType" = false;
                "editor.fontFamily" = "'${theme.font-mono}'";
                "editor.fontSize" = 14;
                "editor.formatOnSave" = true;
                "editor.minimap.enabled" = false;
                "editor.multiCursorModifier" = "ctrlCmd";
                "editor.renderWhitespace" = "all";
                "editor.scrollBeyondLastLine" = false;
                "editor.tabSize" = 2;
                "editor.wordWrap" = "wordWrapColumn";
                "editor.wordWrapColumn" = 80;
                "explorer.confirmDelete" = false;
                "explorer.confirmDragAndDrop" = false;
                "extensions.autoCheckUpdates" = false;
                "extensions.ignoreRecommendations" = true;
                "files.insertFinalNewline" = true;
                "files.trimFinalNewlines" = true;
                "files.trimTrailingWhitespace" = true;
                "git.enableCommitSigning" = true;
                "javascript.updateImportsOnFileMove.enabled" = "always";
                "julia.enableCrashReporter" = false;
                "julia.enableTelemetry" = false;
                "julia.executablePath" = "${julia}/bin/julia";
                "julia.symbolCacheDownload" = false;
                "metals.suggestLatestUpgrade" = false;
                "telemetry.telemetryLevel" = "off";
                "typescript.updateImportsOnFileMove.enabled" = "always";
                "update.mode" = "none";
                "vim.sneak" = true;
                "vim.useSystemClipboard" = true;
                "window.menuBarVisibility" = "toggle";
                "window.zoomLevel" = 0.0;
                "workbench.activityBar.visible" = true;
                "workbench.editor.enablePreview" = false;
                "workbench.editor.enablePreviewFromQuickOpen" = false;
                "workbench.startupEditor" = "none";
                "[javascript]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[json]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[jsonc]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescript]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescriptreact]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
              };
            };
          };
        };
      };
    };
  };
}
