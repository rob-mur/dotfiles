{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};
  python_list = import ./../../library/python_pkgs.nix {
    inherit pkgs;
  };
  r_list = import ./../../library/r_pkgs.nix {
    inherit pkgs;
  };
  julia_list = import ./../../library/julia_pkgs.nix {
    inherit pkgs;
  };

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        helix = {
          enable = true;
          defaultEditor = true;
          settings = {
            theme = "base16_transparent";
            editor = {
              bufferline = "always";
              cursorline = true;
              cursorcolumn = true;
              line-number = "relative";
              rulers = [80];
              true-color = true;
              indent-guides = {
                render = true;
                character = "┊";
                skip-levels = 0;
              };
              lsp = {
                display-messages = true;
              };
              soft-wrap = {
                enable = true;
                max-indent-retain = 0;
                max-wrap = 25;
                wrap-at-text-width = true;
              };
              whitespace.render = {
                space = "all";
                tab = "all";
                newline = "none";
              };
            };
            keys = {
              normal = {
                space = {
                  a = ":toggle-option soft-wrap.enable";
                  l = ":pipe fmt -w 80";
                };
              };
              insert = {
                up = "no_op";
                down = "no_op";
                left = "no_op";
                right = "no_op";
                pageup = "no_op";
                pagedown = "no_op";
                home = "no_op";
                end = "no_op";
              };
            };
          };
          languages = {
            language = [
              # {
              #   name = "adl";
              #   scope = "source.adl";
              #   injection-regex = "adl";
              #   file-types = [ "adl" ];
              #   roots = [];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "\"" = "\"";
              #     "{" = "}";
              #     "<" = ">";
              #   };
              # }
              # {
              #   name = "alloy";
              #   scope = "source.alloy";
              #   injection-regex = "alloy";
              #   file-types = [ "alloy" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "amber";
              #   scope = "source.ab";
              #   file-types = [ "ab" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "astro";
              #   scope = "source.astro";
              #   injection-regex = "astro";
              #   file-types = [ "astro" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   language-servers = [ "astro-ls" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "awk";
              #   scope = "source.awk";
              #   injection-regex = "awk";
              #   file-types = [
              #     "awk"
              #     "gawk"
              #     "nawk"
              #     "mawk"
              #   ];
              #   comment-token = "#";
              #   language-servers = [ "awk-language-server" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              {
                name = "bash";
                scope = "source.bash";
                injection-regex = "(shell|bash|zsh|sh)";
                file-types = [
                  "Renviron"
                  "ash"
                  "bash"
                  "bashrc_Apple_Terminal"
                  "bazelrc"
                  "cshrc"
                  "dash"
                  "ebuild"
                  "eclass"
                  "ksh"
                  "mksh"
                  "sh"
                  "tcshrc"
                  "zlogin"
                  "zlogout"
                  "zprofile"
                  "zsh"
                  "zsh-theme"
                  "zshenv"
                  "zshrc"
                  "zshrc_Apple_Terminal"
                  { glob = ".Renviron"; }
                  { glob = ".bash_aliases"; }
                  { glob = ".bash_history"; }
                  { glob = ".bash_login"; }
                  { glob = ".bash_logout"; }
                  { glob = ".bash_profile"; }
                  { glob = ".bashrc"; }
                  { glob = ".hushlogin"; }
                  { glob = ".profile"; }
                  { glob = ".tmux.conf"; }
                  { glob = ".xinitrc"; }
                  { glob = ".xprofile"; }
                  { glob = ".xserverrc"; }
                  { glob = ".xsession"; }
                  { glob = ".xsessionrc"; }
                  { glob = ".yash_profile"; }
                  { glob = ".yashrc"; }
                  { glob = ".zimrc"; }
                  { glob = ".zlogin"; }
                  { glob = ".zlogout"; }
                  { glob = ".zprofile"; }
                  { glob = ".zshenv"; }
                  { glob = ".zshrc"; }
                  { glob = "APKBUILD"; }
                  { glob = "i3/config"; }
                  { glob = "sway/config"; }
                  { glob = "tmux.conf"; }
                  { glob = "xinitrc"; }
                  { glob = "xserverrc"; }
                ];
                shebangs = [ "sh" "bash" "dash" "zsh" ];
                comment-token = "#";
                language-servers = [
                  "bash-language-server"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              # {
              #   name = "beancount";
              #   scope = "source.beancount";
              #   injection-regex = "beancount";
              #   file-types = [
              #     "beancount"
              #     "bean"
              #   ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "beancount-language-server" ];
              # }
              {
                name = "bibtex";
                scope = "source.bib";
                injection-regex = "bib";
                file-types = [ "bib" ];
                comment-token = "%";
                language-servers = [
                  "typos-lsp"
                  "texlab"
                ];
                indent = {
                  tab-width = 4;
                  unit = "\t";
                };
                auto-format = true;
                formatter = {
                  command = "${bibtex-tidy}/bin/bibtex-tidy";
                  args = [
                    "-"
                    "--curly"
                    "--drop-all-caps"
                    "--remove-empty-fields"
                    "--sort-fields"
                    "--sort=year,author,id"
                    "--strip-enclosing-braces"
                    "--trailing-commas"
                  ];
                };
              }
              # {
              #   name = "bicep";
              #   scope = "source.bicep";
              #   file-types = [
              #     "bicep"
              #     "bicepparam"
              #   ];
              #   auto-format = true;
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = " ";
              #   };
              #   language-servers = [ "bicep-langserver" ];
              # }
              # {
              #   name = "bitbake";
              #   language-servers = [ "bitbake-language-server" ];
              #   scope = "source.bitbake";
              #   file-types = [
              #     "bb"
              #     "bbappend"
              #     "bbclass"
              #     {glob = "conf/*.conf"; }
              #     {glob = "conf/*/*.{inc,conf}"; }
              #     {glob = "recipe-*/*/*.inc"; }
              #   ];
              #   comment-token = "#";
              # }
              # {
              #   name = "blade";
              #   scope = "source.blade.php";
              #   file-types = [
              #     "blade"
              #     { glob = "*.blade.php"; }
              #   ];
              #   injection-regex = "blade";
              #   roots = [
              #     "composer.json"
              #     "index.php"
              #   ];
              # }
              # {
              #   name = "blueprint";
              #   scope = "source.blueprint";
              #   injection-regex = "blueprint";
              #   file-types = [ "blp" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "blueprint-compiler" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "c";
              #   scope = "source.c";
              #   injection-regex = "c";
              #   file-types = [ "c" ]; # TODO: [ "h" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "clangd"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   debugger = {
              #     name = "lldb-dap";
              #     transport = "stdio";
              #     command = "${lldb}/bin/lldb-dap";
              #     templates = [
              #       {
              #         name = "binary";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           console = "internalConsole";
              #           pid = "{0}";
              #         };
              #       }
              #       {
              #         name = "gdbserver attach";
              #         request = "attach";
              #         completion = [
              #           {
              #             name = "lldb connect url";
              #             default = "connect://localhost:3333";
              #           }
              #           {
              #             name = "file";
              #             completion = "filename";
              #           }
              #           "pid"
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           attachCommands = [
              #             "platform select remote-gdb-server"
              #             "platform connect {0}"
              #             "file {1}" "attach {2}"
              #           ];
              #         };
              #       }
              #     ];
              #   };
              # }
              {
                name = "cabal";
                scope = "source.cabal";
                file-types = [ "cabal" ];
                roots = [ "cabal.project" "Setup.hs" ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                comment-token = "--";
                language-servers = [
                  "haskell-language-server"
                ];
              }
              # {
              #   name = "caddyfile";
              #   scope = "source.caddyfile";
              #   injection-regex = "caddyfile";
              #   file-types = [
              #     { glob = "Caddyfile"; }
              #   ];
              #   comment-tokens = [ "#" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   formatter = {
              #     command = "${caddy}/bin/caddy";
              #     args = [ "fmt" "-" ];
              #   };
              #   auto-format = true;
              # }
              # {
              #   name = "cairo";
              #   scope = "source.cairo";
              #   injection-regex = "cairo";
              #   file-types = [ "cairo" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   # auto-format = true;
              #   language-servers = [ "cairo-language-server" ];
              # }
              # {
              #   name = "capnp";
              #   scope = "source.capnp";
              #   injection-regex = "capnp";
              #   file-types = [ "capnp" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "cel";
              #   scope = "source.cel";
              #   injection-regex = "cel";
              #   file-types = [ "cel" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "comment";
              #   scope = "scope.comment";
              #   file-types = [];
              #   injection-regex = "comment";
              # }
              # {
              #   name = "cpon";
              #   scope = "scope.cpon";
              #   injection-regex = "cpon";
              #   file-types = [
              #     "cpon" "cp"
              #   ];
              #   auto-format = true;
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "cpp";
              #   scope = "source.cpp";
              #   injection-regex = "cpp";
              #   file-types = [
              #     "cc" "hh" "c++" "cpp" "hpp" "h" "ipp" "tpp" "cxx"
              #     "hxx" "ixx" "txx" "ino" "C" "H" "cu" "cuh" "cppm"
              #     "h++" "ii" "inl"
              #     { glob = ".hpp.in"; } { glob = ".h.in"; }
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "clangd"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   debugger = {
              #     name = "lldb-dap";
              #     transport = "stdio";
              #     command = "${lldb}/bin/lldb-dap";
              #     templates = [
              #       {
              #         name = "binary";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           console = "internalConsole";
              #           pid = "{0}";
              #         };
              #       }
              #       {
              #         name = "gdbserver attach";
              #         request = "attach";
              #         completion = [
              #           {
              #             name = "lldb connect url";
              #             default = "connect://localhost:3333";
              #           }
              #           {
              #             name = "file";
              #             completion = "filename";
              #           }
              #           "pid"
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           attachCommands = [
              #             "platform select remote-gdb-server"
              #             "platform connect {0}"
              #             "file {1}"
              #             "attach {2}"
              #           ];
              #         };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "clojure";
              #   scope = "source.clojure";
              #   injection-regex = "(clojure|clj|edn|boot)";
              #   file-types = [
              #     "boot" "clj" "cljc" "clje" "cljr" "cljs" "cljx" "edn"
              #   ];
              #   roots = [
              #     "project.clj" "build.boot" "deps.edn" "shadow-cljs.edn"
              #   ];
              #   comment-token = ";";
              #   language-servers = [
              #     "clojure-lsp"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "cmake";
              #   scope = "source.cmake";
              #   file-types = [
              #     "cmake"
              #     { glob = "CMakeLists.txt"; }
              #   ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "#[[";
              #     end = "]]";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [
              #     "cmake-language-server"
              #     "neocmakelsp"
              #   ];
              #   injection-regex = "cmake";
              # }
              # {
              #   name = "cross-config";
              #   scope = "source.cross-config";
              #   injection-regex = "cross(-config)";
              #   grammar = "toml";
              #   comment-token = "#";
              #   file-types = [
              #     { glob = "Cross.toml";}
              #   ];
              #   language-servers = [
              #     "taplo" "tombi"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "crystal";
              #   scope = "source.cr";
              #   file-types = [ "cr" ];
              #   roots = [
              #     "shard.yml"
              #     "shard.lock"
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "ruby";
              #   language-servers = [ "crystalline" "ameba-ls" ];
              #   formatter = {
              #     command = "${crystal}/bin/crystal";
              #     args = [
              #       "tool" "format" "-"
              #     ];
              #   };
              # }
              # {
              #   name = "css";
              #   scope = "source.css";
              #   injection-regex = "css";
              #   file-types = [ "css" "scss" ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "vscode-css-language-server" ];
              #   auto-format = true;
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "csv";
              #   file-types = [ "csv" ];
              #   scope = "source.csv";
              # }
              # {
              #   name = "cue";
              #   scope = "source.cue";
              #   injection-regex = "cue";
              #   file-types = [ "cue" ];
              #   roots = [ "cue.mod" ];
              #   auto-format = true;
              #   comment-token = "//";
              #   language-servers = [ "cuelsp" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   formatter = {
              #     command = "${cue}/bin/cue";
              #     args = [ "fmt" "-" ];
              #   };
              # }
              # {
              #   name = "c-sharp";
              #   scope = "source.csharp";
              #   injection-regex = "c-?sharp";
              #   file-types = [ "cs" "csx" "cake" ];
              #   roots = [ "sln" "csproj" ];
              #   comment-token = "//";
              #   block-comment-tokens = { start = "/*"; end = "*/"; };
              #   indent = { tab-width = 4; unit = "\t"; };
              #   language-servers = [
              #     "omnisharp"
              #   ];
              #   debugger = {
              #     name = "netcoredbg";
              #     transport = "tcp";
              #     command = "${netcoredbg}/bin/netcoredbg";
              #     args = [ "--interpreter=vscode" ];
              #     port-arg = "--server={}";
              #     templates = [
              #       {
              #         name = "launch";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "path to dll";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           type = "coreclr";
              #           console = "internalConsole";
              #           internalConsoleOptions = "openOnSessionStart";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           processId = "{0}";
              #         };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "cylc";
              #   scope = "source.cylc";
              #   injection-regex = "cylc";
              #   file-types = [
              #     "cylc"
              #     { glob = "suite.rc"; }
              #   ];
              #   comment-tokens = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              {
                name = "cython";
                scope = "source.cython";
                file-types = [ "pxd" "pxi" "pyx" ];
                comment-token = "#";
                roots = [
                  "pyproject.toml"
                  "setup.py"
                  "poetry.lock"
                ];
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
              }
              # {
              #   name = "d";
              #   scope = "source.d";
              #   file-types = [ "d" "dd" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   injection-regex = "d";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "serve-d" ];
              #   formatter = {
              #     command = "${dfmt}/bin/dfmt";
              #   };
              # }
              # {
              #   name = "dbml";
              #   scope = "source.dbml";
              #   injection-regex = "dbml";
              #   file-types = [ "dbml" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "dart";
              #   scope = "source.dart";
              #   file-types = [ "dart" ];
              #   roots = [ "pubspec.yaml" ];
              #   auto-format = true;
              #   comment-tokens = [
              #     "//"  "///"
              #   ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "dart"
              #   ];
              #   indent = {
              #     tab-width = 2; unit = "  ";
              #   };
              # }
              # {
              #   name = "debian";
              #   scope = "text.debian";
              #   file-types = [
              #     "dsc"
              #     "changes"
              #     { glob = "debian/**/control"; }
              #     { glob = "etc/apt/sources.list.d/*.sources"; }
              #   ];
              #   comment-tokens = "#";
              # }
              # {
              #   name = "devicetree";
              #   scope = "source.devicetree";
              #   injection-regex = "(dtsi?|devicetree|fdt)";
              #   file-types = [ "dts" "dtsi" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   language-servers = [ "dts-lsp" ];
              # }
              # {
              #   name = "dhall";
              #   scope = "source.dhall";
              #   injection-regex = "dhall";
              #   file-types = [ "dhall" ];
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "{-"; end = "-}"; };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "dhall-lsp-server" ];
              #   formatter = {
              #     command = "${dhall}/bin/dhall";
              #     args = [ "format" ];
              #   };
              # }
              # {
              #   name = "djot";
              #   scope = "source.djot";
              #   injection-regex = "dj|djot";
              #   file-types = [ "dj" "djot" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   block-comment-tokens = {
              #     start = "{%";
              #     end = "%}";
              #   };
              # }
              # {
              #   name = "dockerfile";
              #   scope = "source.dockerfile";
              #   injection-regex = "docker|dockerfile";
              #   roots = [ "Dockerfile" "Containerfile" ];
              #   file-types = [
              #     "Dockerfile"
              #     { glob = "Dockerfile"; }
              #     { glob = "Dockerfile.*"; }
              #     "dockerfile"
              #     { glob = "dockerfile"; }
              #     { glob = "dockerfile.*"; }
              #     "Containerfile"
              #     { glob = "Containerfile"; }
              #     { glob = "Containerfile.*"; }
              #     "containerfile"
              #     { glob = "containerfile"; }
              #     { glob = "containerfile.*"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "docker-langserver" ];
              # }
              # {
              #   name = "docker-bake";
              #   scope = "source.docker-bake";
              #   injection-regex = "docker-bake";
              #   grammar = "hcl";
              #   file-types = [
              #     { glob = "docker-bake.hcl"; }
              #     { glob = "docker-bake.override.hcl"; }
              #   ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "docker-language-server" ];
              # }
              # {
              #   name = "docker-compose";
              #   scope = "source.yaml.docker-compose";
              #   roots = [
              #     "docker-compose.yaml"
              #     "docker-compose.yml"
              #   ];
              #   language-servers = [
              #     "docker-compose-langserver"
              #     "yaml-language-server"
              #     "docker-language-server"
              #   ];
              #   file-types = [
              #     { glob = "docker-compose.yaml"; }
              #     { glob = "docker-compose.yml"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "yaml";
              # }
              # {
              #   name = "dot";
              #   scope = "source.dot";
              #   injection-regex = "dot";
              #   file-types = [ "dot" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "dot-language-server" ];
              # }
              # {
              #   name = "doxyfile";
              #   scope = "source.doxyfile";
              #   injection-regex = "[Dd]oxyfile";
              #   file-types = [
              #     { glob = "Doxyfile"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "dtd";
              #   scope = "source.dtd";
              #   injection-regex = "dtd";
              #   file-types = [
              #     "dtd" "ent"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              # }
              # {
              #   name = "dune";
              #   scope = "source.dune";
              #   roots = [ "dune-project" ];
              #   file-types = [
              #     { glob = "dune-project"; }
              #     { glob = "dune"; }
              #     ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 1;
              #     unit = " ";
              #   };
              #   grammar = "scheme";
              #   auto-format = true;
              #   formatter = {
              #     command = "${dune_3}/bin/dune";
              #     args = [
              #       "format-dune-file"
              #     ];
              #   };
              #   auto-pairs = {
              #   "(" = ")";
              #   "{" = "}";
              #   "[" = "]";
              #   "\"" = "\"";
              #   };
              # }
              # {
              #   name = "dunstrc";
              #   scope = "source.dunstrc";
              #   comment-tokens = [ "#" ";" ];
              #   file-types = [
              #     { glob = "dunst/dunstrc"; }
              #   ];
              # }
              # {
              #   name = "earthfile";
              #   scope = "source.earthfile";
              #   injection-regex = "earthfile";
              #   roots = [ "Earthfile" ];
              #   file-types = [
              #     { glob = "Earthfile"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "earthlyls" ];
              # }
              # {
              #   name = "erb";
              #   scope = "text.html.erb";
              #   injection-regex = "erb";
              #   file-types = [ "erb" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "embedded-template";
              # }
              # {
              #   name = "esdl";
              #   scope = "source.esdl";
              #   injection-regex = "esdl";
              #   file-types = [ "esdl" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   roots = [ "edgedb.toml" ];
              # }
              # {
              #   name = "ejs";
              #   scope = "text.html.ejs";
              #   injection-regex = "ejs";
              #   file-types = [ "ejs" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "embedded-template";
              # }
              # {
              #   name = "eex";
              #   scope = "source.eex";
              #   injection-regex = "eex";
              #   file-types = [ "eex" ];
              #   roots = [
              #     "mix.exs" "mix.lock"
              #   ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "heex";
              #   scope = "source.heex";
              #   injection-regex = "heex";
              #   file-types = [ "heex" ];
              #   roots = [
              #     "mix.exs"
              #     "mix.lock"
              #   ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "elixir-ls" ];
              # }
              # {
              #   name = "edoc";
              #   scope = "source.edoc";
              #   file-types = [
              #     "edoc" "edoc.in"
              #   ];
              #   injection-regex = "edoc";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "jsdoc";
              #   scope = "source.jsdoc";
              #   injection-regex = "jsdoc";
              #   file-types = [ "jsdoc" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "elisp";
              #   scope = "source.elisp";
              #   file-types = [ "el" ];
              #   comment-tokens = [ ";" ];
              #   auto-pairs = {
              #     "(" = ")";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "elixir";
              #   scope = "source.elixir";
              #   injection-regex = "(elixir|ex)";
              #   file-types = [
              #     "ex" "exs"
              #     { glob = "mix.lock"; }
              #   ];
              #   shebangs = [ "elixir" ];
              #   roots = [ "mix.exs" "mix.lock" ];
              #   comment-token = "#";
              #   language-servers = [ "elixir-ls" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "elm";
              #   scope = "source.elm";
              #   injection-regex = "elm";
              #   file-types = [ "elm" ];
              #   roots = [ "elm.json" ];
              #   auto-format = true;
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "{-";
              #     end = "-}";
              #   };
              #   language-servers = [ "elm-language-server" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "elvish";
              #   scope = "source.elvish";
              #   shebangs = [ "elvish" ];
              #   file-types = [ "elv" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "elvish" ];
              #   grammar = "elvish";
              # }
              {
                name = "env";
                scope = "source.env";
                file-types = [
                  { glob = ".env"; }
                  { glob = ".env.*"; }
                  { glob = ".envrc"; }
                  { glob = ".envrc.*"; }
                ];
                injection-regex = "env";
                comment-token = "#";
                indent = {
                  tab-width = 4;
                  unit = "\t";
                };
                grammar = "bash";
              }
              # {
              #   name = "erlang";
              #   scope = "source.erlang";
              #   injection-regex = "erl(ang)?";
              #   file-types = [
              #     "erl" "hrl" "app"
              #     { glob = "rebar.config"; }
              #     { glob = "rebar.lock"; }
              #     { glob = "*.app.src"; }
              #   ];
              #   roots = [ "rebar.config" ];
              #   shebangs = [ "escript" ];
              #   comment-token = "%%";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [
              #     {
              #       name = "elp";
              #       except-features = [
              #         "document-symbols" "workspace-symbols"
              #       ];
              #     }
              #   ];
              # }
              # {
              #   name = "fennel";
              #   scope = "source.fennel";
              #   file-types = [ "fnl" "fnlm" ];
              #   shebangs = [ "fennel" ];
              #   comment-token = ";";
              #   language-servers = [ "fennel-ls" ];
              #   formatter = {
              #     command = "${fnlfmt}/bin/fnlfmt";
              #     args = [ "-" ];
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "fga";
              #   scope = "source.fga";
              #   injection-regex = "fga";
              #   file-types = [ "fga" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "fidl";
              #   scope = "source.fidl";
              #   injection-regex = "fidl";
              #   file-types = [ "fidl" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-pairs = {
              #   "\"" = "\"";
              #   "{" = "}";
              #   "(" = ")";
              #   "<" = ">";
              #   };
              # }
              {
                name = "fish";
                scope = "source.fish";
                injection-regex = "fish";
                file-types = [ "fish" ];
                shebangs = [ "fish" ];
                comment-token = "#";
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
                auto-format = true;
                formatter = {
                  command = "${fish}/bin/fish_indent";
                };
              }
              # {
              #   name = "fortran";
              #   scope = "source.fortran";
              #   injection-regex = "fortran";
              #   file-types = [
              #     "f" "for" "f90" "f95" "f03"
              #   ];
              #   roots = [ "fpm.toml" ];
              #   comment-token = "!";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "fortls" ];
              # }
              # {
              #   name = "fsharp";
              #   scope = "source.fs";
              #   roots = [ "sln" "fsproj" ];
              #   injection-regex = "fsharp";
              #   file-types = [ "fs" "fsx" "fsi" "fsscript" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "(*";
              #     end = "*)";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-format = true;
              #   language-servers = [ "fsharp-ls" ];
              # }
              # {
              #   name = "gas";
              #   scope = "source.gas";
              #   file-types = [ "s" ];
              #   injection-regex = "gas";
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 8;
              #     unit = "        ";
              #   };
              #   language-servers = [ "asm-lsp" ];
              # }
              # {
              #   name = "gemini";
              #   scope = "source.gmi";
              #   file-types = [ "gmi" ];
              # }
              # {
              #   name = "gherkin";
              #   scope = "source.feature";
              #   file-types = [ "feature" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "ghostty";
              #   scope = "source.ghostty";
              #   file-types = [
              #     { glob = "ghostty/config"; }
              #   ];
              #   comment-tokens = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              {
                name = "git-attributes";
                scope = "source.gitattributes";
                file-types = [
                  { glob = ".gitattributes"; }
                  { glob = ".config/git/attributes"; }
                ];
                injection-regex = "git-attributes";
                comment-token = "#";
                grammar = "gitattributes";
              }
              {
                name = "git-cliff-config";
                scope = "source.git-cliff-config";
                injection-regex = "git-cliff(-config)";
                grammar = "toml";
                comment-token = "#";
                file-types = [
                  { glob = "cliff.toml"; }
                ];
                language-servers = [
                  "taplo" "tombi"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              {
                name = "git-commit";
                scope = "git.commitmsg";
                file-types = [
                  { glob = "COMMIT_EDITMSG"; }
                  { glob = "MERGE_MSG"; }
                ];
                comment-token = "#";
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                rulers = [ 51 73 ];
                text-width = 72;
                language-servers = [
                  "harper-ls"
                ];
              }
              {
                name = "git-config";
                scope = "source.gitconfig";
                file-types = [
                  "gitconfig"
                  { glob = ".config/git/config"; }
                  { glob = ".git/config"; }
                  { glob = ".gitconfig"; }
                  { glob = ".gitmodules"; }
                ];
                injection-regex = "git-config";
                comment-token = "#";
                indent = {
                  tab-width = 4;
                  unit = "\t";
                };
              }
              {
                name = "git-ignore";
                scope = "source.gitignore";
                file-types = [
                  { glob = ".*ignore"; }
                  { glob = ".config/helix/ignore"; }
                  { glob = ".git-blame-ignore-revs"; }
                  { glob = ".git/info/exclude"; }
                  { glob = ".gitignore_global"; }
                  { glob = ".helix/ignore"; }
                  { glob = ".ignore"; }
                  { glob = "CODEOWNERS"; }
                  { glob = "git/ignore"; }
               ];
                injection-regex = "git-ignore";
                comment-token = "#";
                grammar = "gitignore";
              }
              {
                name = "git-notes";
                scope = "git.notesmsg";
                file-types = [
                  { glob = "NOTES_EDITMSG"; }
                ];
                comment-token = "#";
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
                rulers = [73];
                text-width = 72;
                grammar = "gitcommit";
              }
              {
                name = "git-rebase";
                scope = "source.gitrebase";
                file-types = [
                  { glob = "git-rebase-todo"; }
                ];
                injection-regex = "git-rebase";
                comment-token = "#";
                indent = {
                  tab-width = 2;
                  unit = "\t";
                };
              }
              # {
              #   name = "glimmer";
              #   scope = "source.glimmer";
              #   injection-regex = "hbs";
              #   file-types = [
              #     {
              #       glob = "{app,addon}/{components,templates}/*.hbs";
              #     }
              #   ];
              #   block-comment-tokens = {
              #     start = "{{!";
              #     end = "}}";
              #   };
              #   roots = [
              #     "package.json"
              #     "ember-cli-build.js"
              #   ];
              #   grammar = "glimmer";
              #   language-servers = [ "ember-language-server" ];
              #   formatter = {
              #     command = "${prettier}/bin/prettier";
              #     args = [
              #       "--parser" "glimmer"
              #     ];
              #   };
              #   auto-pairs = {
              #     "<" = ">";
              #     "'" = "'";
              #     "{" = "}";
              #     "(" = ")";
              #     "\"" = "\"";
              #   };
              # }
              {
                name = "diff";
                scope = "source.diff";
                file-types = [
                  "diff"
                  "patch"
                  "rej"
                ];
                injection-regex = "diff";
                comment-token = "#";
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              # {
              #   name = "gleam";
              #   scope = "source.gleam";
              #   injection-regex = "gleam";
              #   file-types = [ "gleam" ];
              #   roots = [ "gleam.toml" ];
              #   comment-tokens = [
              #     "//" "///" "////"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "gleam" ];
              #   auto-format = true;
              # }
              # {
              #   name = "gdscript";
              #   scope = "source.gdscript";
              #   injection-regex = "gdscript";
              #   file-types = [ "gd" ];
              #   shebangs = [];
              #   roots = [ "project.godot" ];
              #   auto-format = true;
              #   formatter = {
              #     # command = "${gdtoolkit_3}/bin/gdformat"; # broken
              #     command = "gdformat";
              #     args = [ "-" ];
              #   };
              #   comment-tokens = [
              #     "#"  "##"
              #   ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "gitlab-ci";
              #   scope = "source.gitlab-ci";
              #   injection-regex = "^gitlab-ci$";
              #   file-types = [
              #     { glob = ".gitlab-ci.yml"; }
              #   ];
              #   grammar = "yaml";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "yaml-language-server" "gitlab-ci-ls" ];
              #   comment-token = "#";
              # }
              # {
              #   name = "gjs";
              #   scope = "source.gjs";
              #   file-types = [ "gjs" ];
              #   roots = [
              #     "package.json"
              #     "ember-cli-build.js"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     {
              #       except-features = [
              #         "format"
              #         "diagnostics"
              #       ];
              #       name = "typescript-language-server";
              #     }
              #     "vscode-eslint-language-server"
              #     "ember-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "javascript";
              #   auto-pairs = {
              #     "<" = ">";
              #     "'" = "'";
              #     "{" = "}";
              #     "(" = ")";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "glsl";
              #   scope = "source.glsl";
              #   file-types = [
              #     "glsl"
              #     "vert"
              #     "tesc"
              #     "tese"
              #     "geom"
              #     "frag"
              #     "comp"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "glsl_analyzer" ];
              #   injection-regex = "glsl";
              # }
              # {
              #   name = "gts";
              #   scope = "source.gts";
              #   file-types = [ "gts" ];
              #   roots = [
              #     "package.json"
              #     "ember-cli-build.js"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     {
              #       except-features = [
              #         "format"
              #         "diagnostics"
              #       ];
              #       name = "typescript-language-server";
              #     }
              #     "vscode-eslint-language-server"
              #     "ember-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "typescript";
              #   auto-pairs = {
              #     "<" = ">";
              #     "'" = "'";
              #     "{" = "}";
              #     "(" = ")";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "gn";
              #   scope = "source.gn";
              #   injection-regex = "gn";
              #   file-types = [
              #     "gn"
              #     "gni"
              #   ];
              #   roots = [];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #      unit = "  ";
              #   };
              #   formatter = {
              #     command = "${gn}/bin/gn";
              #     args = [
              #       "format"
              #       "--stdin"
              #     ];
              #   };
              # }
              # {
              #   name = "go";
              #   scope = "source.go";
              #   injection-regex = "go";
              #   file-types = [ "go" ];
              #   roots = [ "go.work" "go.mod" ];
              #   auto-format = true;
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "golangci-lint-lsp"
              #     "gopls"
              #   ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   debugger = {
              #     name = "go";
              #     transport = "tcp";
              #     command = "${delve}/bin/dlv";
              #     args = [ "dap" ];
              #     port-arg = "-l 127.0.0.1:{}";
              #     templates = [
              #       {
              #         name = "source";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "entrypoint";
              #             completion = "filename";
              #             default = ".";
              #           }
              #         ];
              #         args = {
              #           mode = "debug";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "binary";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           mode = "exec";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "test";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "tests";
              #             completion = "directory";
              #             default = ".";
              #           }
              #         ];
              #         args = {
              #           mode = "test";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           mode = "local";
              #           processId = "{0}";
              #         };
              #       }
              #       {
              #         name = "core";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #           {
              #             name = "core";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           mode = "core";
              #           program = "{0}";
              #           coreFilePath = "{1}";
              #         };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "godot-resource";
              #   scope = "source.tscn";
              #   injection-regex = "godot";
              #   file-types = [ "tscn" "tres" "godot" "gdextension" ];
              #   shebangs = [];
              #   roots = [ "project.godot" ];
              #   auto-format = false;
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "gomod";
              #   scope = "source.gomod";
              #   injection-regex = "gomod";
              #   file-types = [
              #     { glob = "go.mod"; }
              #   ];
              #   auto-format = true;
              #   comment-token = "//";
              #   language-servers = [ "gopls" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "gotmpl";
              #   scope = "source.gotmpl";
              #   injection-regex = "gotmpl";
              #   file-types = [ "gotmpl" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "gopls" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = " ";
              #   };
              # }
              # {
              #   name = "gowork";
              #   scope = "source.gowork";
              #   injection-regex = "gowork";
              #   file-types = [
              #     { glob = "go.work"; }
              #   ];
              #   auto-format = true;
              #   comment-token = "//";
              #   language-servers = [ "gopls" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "go-format-string";
              #   scope = "source.go-format-string";
              #   file-types = [];
              #   injection-regex = "go-format-string";
              # }
              # {
              #   name = "graphql";
              #   scope = "source.graphql";
              #   injection-regex = "graphql";
              #   file-types = [
              #     "gql" "graphql" "graphqls"
              #   ];
              #   language-servers = [ "graphql-language-server" ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "\"\"\"";
              #     end = "\"\"\"";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "gren";
              #   scope = "source.gren";
              #   injection-regex = "gren";
              #   file-types = [ "gren" ];
              #   roots = [ "gren.json" ];
              #   comment-tokens = "--";
              #   block-comment-tokens = {
              #     start = "{-";
              #     end = "-}";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "groovy";
              #   language-id = "groovy";
              #   scope = "source.groovy";
              #   file-types = [
              #     "gradle"
              #     "groovy"
              #     "jenkinsfile"
              #     { glob = "Jenkinsfile"; }
              #     { glob = "Jenkinsfile.*"; }
              #   ];
              #   shebangs = [ "groovy" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "hare";
              #   scope = "source.hare";
              #   injection-regex = "hare";
              #   file-types = [ "ha" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 8;
              #     unit = "\t";
              #   };
              # }
              {
                name = "haskell";
                scope = "source.haskell";
                injection-regex = "hs|haskell";
                file-types = [ "hs" "hs-boot" ];
                roots = [ "Setup.hs" "stack.yaml" "cabal.project" ];
                shebangs = [
                  "runhaskell" "stack"
                ];
                comment-token = "--";
                block-comment-tokens = {
                  start = "{-";
                  end = "-}";
                };
                language-servers = [
                  "haskell-language-server"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              {
                name = "haskell-persistent";
                scope = "source.persistentmodels";
                file-types = [ "persistentmodels" ];
                comment-token = "--";
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              # {
              #   name = "hcl";
              #   scope = "source.hcl";
              #   injection-regex = "(hcl|tf|nomad)";
              #   language-id = "terraform";
              #   file-types = [
              #     "hcl" "tf" "nomad"
              #   ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "terraform-ls" ];
              #   auto-format = true;
              # }
              # {
              #   name = "hdl";
              #   scope = "source.hdl";
              #   file-types = [ "hdl" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   injection-regex = "hdl";
              #   language-servers = [ "hdls" ];
              # }
              # {
              #   name = "helm";
              #   grammar = "gotmpl";
              #   scope = "source.helm";
              #   roots = [ "Chart.yaml" ];
              #   comment-token = "#";
              #   language-servers = [ "helm_ls" ];
              #   file-types = [
              #     { glob = "templates/*.yaml"; }
              #     { glob = "templates/*.yml"; }
              #     { glob = "templates/_*.tpl"; }
              #     { glob = "templates/NOTES.txt"; }
              #   ];
              # }
              # {
              #   name = "hoon";
              #   scope = "source.hoon";
              #   injection-regex = "hoon";
              #   file-types = [ "hoon" ];
              #   comment-token = "::";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "hocon";
              #   scope = "source.conf";
              #   file-types = [
              #     { glob = "**/src/*/resources/**/*.conf"; }
              #     { glob = "*scalafmt*.conf"; }
              #     { glob = "*scalafix*.conf"; }
              #   ];
              #   comment-token = "#";
              #   auto-format = true;
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "hosts";
              #   scope = "source.hosts";
              #   file-types = [
              #     { glob = "hosts"; }
              #   ];
              #   comment-token = "#";
              # }
              # {
              #   name = "html";
              #   scope = "text.html.basic";
              #   injection-regex = "html";
              #   file-types = [
              #     "asp" "aspx" "htm" "html" "jshtm" "jsp"
              #     "rhtml" "shtml" "volt" "xht" "xhtml"
              #   ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   language-servers = [
              #     "vscode-html-language-server"
              #     "superhtml"
              #   ];
              #   auto-format = true;
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "hurl";
              #   scope = "source.hurl";
              #   injection-regex = "hurl";
              #   file-types = [ "hurl" ];
              #   comment-token = "#";
              #   formatter = {
              #     command = "${hurl}/bin/hurlfmt";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "hyprlang";
              #   scope = "source.hyprlang";
              #   roots = [ "hyprland.conf" ];
              #   file-types = [
              #     { glob = "hypr/*.conf"; }
              #   ];
              #   comment-token = "#";
              #   grammar = "hyprlang";
              #   language-servers = [ "hyprls" ];
              # }
              # {
              #   name = "idris";
              #   scope = "source.idr";
              #   injection-regex = "idr";
              #   file-types = [ "idr" ];
              #   shebangs = [];
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "{-";
              #     end = "-}";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "idris2-lsp" ];
              # }
              # {
              #   name = "iex";
              #   scope = "source.iex";
              #   injection-regex = "iex";
              #   file-types = [ "iex" ];
              #   comment-token = "#";
              # }
              # {
              #   name = "ini";
              #   scope = "source.ini";
              #   file-types = [
              #     "ini"
              #     "desktop"
              #     { glob = "mimeapps.list"; }
              #     # Podman quadlet
              #     "container"
              #     "volume"
              #     "kube"
              #     "network"
              #     { glob = ".editorconfig"; }
              #     { glob = ".npmrc"; }
              #     { glob = "hgrc"; }
              #     { glob = "npmrc"; }
              #     { glob = "rclone.conf"; }
              #     { glob = ".aws/config"; }
              #     "properties"
              #     "cfg"
              #     "directory"
              #     { glob = ".wslconfig"; }
              #   ];
              #   injection-regex = "ini";
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "ink";
              #   scope = "source.ink";
              #   file-types = [ "ink" ];
              #   injection-regex = "ink";
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   soft-wrap = {
              #     enable = true;
              #   };
              # }
              # {
              #   name = "inko";
              #   auto-format = true;
              #   scope = "source.inko";
              #   injection-regex = "inko";
              #   file-types = [ "inko" ];
              #   roots = [ "inko.pkg" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   formatter = {
              #     # command = "${inko}/bin/inko"; # broken
              #     command = "inko";
              #     args = [
              #       "fmt" "-"
              #     ];
              #   };
              # }
              # {
              #   name = "java";
              #   scope = "source.java";
              #   injection-regex = "java";
              #   file-types = [ "java" "jav" "pde" ];
              #   roots = [
              #     "pom.xml"
              #     "build.gradle"
              #     "build.gradle.kts"
              #   ];
              #   language-servers = [
              #     "jdtls"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   comment-tokens = [ "//" ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              # }
              # {
              #   name = "javascript";
              #   scope = "source.js";
              #   injection-regex = "(js|javascript)";
              #   language-id = "javascript";
              #   file-types = [
              #     "js" "mjs" "cjs" "rules" "es6" "pac"
              #     { glob = ".node_repl_history"; }
              #     { glob = "jakefile"; }
              #   ];
              #   shebangs = [ "node" ];
              #   roots = [ "package.json" "jsconfig.json" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "typescript-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   debugger = {
              #     name = "node-debug2";
              #     transport = "stdio";
              #     quirks = { absolute-paths = true; };
              #     templates = [
              #       {
              #         name = "source";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "main";
              #             completion = "filename";
              #             default = "index.js";
              #           }
              #         ];
              #         args = { program = "{0}"; };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "jinja";
              #   scope = "text.html.jinja";
              #   injection-regex = "jinja";
              #   file-types = [ "jinja" "jinja2" "j2" ];
              #   indent = { tab-width = 2; unit = "  "; };
              #   grammar = "jinja2";
              #   block-comment-tokens = { start = "{#"; end = "#}"; };
              # }
              # {
              #   name = "jjconfig";
              #   scope = "source.jjconfig";
              #   injection-regex = "jjconfig";
              #   grammar = "toml";
              #   file-types = [
              #     { glob = "jj/config.toml"; }
              #     { glob = "jj/conf.d/*.toml"; }
              #     { glob = ".jj/repo/*.toml"; }
              #   ];
              #   comment-token = "#";
              #   language-servers = [ "taplo" "tombi" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "jjdescription";
              #   scope = "jj.description";
              #   file-types = [
              #     { glob = "*.jjdescription"; }
              #   ];
              #   comment-token = "JJ:";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   rulers = [51 73];
              #   text-width = 72;
              # }
              # {
              #   name = "jjrevset";
              #   scope = "jj.revset";
              #   file-types = [ "jjrevset" ];
              # }
              # {
              #   name = "jjtemplate";
              #   scope = "jj.template";
              #   file-types = [ "jjtemplate" ];
              # }
              # {
              #   name = "jq";
              #   scope = "source.jq";
              #   injection-regex = "jq";
              #   file-types = [ "jq" ];
              #   comment-token = "#";
              #   language-servers = [ "jq-lsp" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              {
                name = "julia";
                scope = "source.julia";
                injection-regex = "julia";
                file-types = [ "jl" ];
                shebangs = [ "julia" ];
                roots = [ "Manifest.toml" "Project.toml" ];
                comment-token = "#";
                block-comment-tokens = {
                  start = "#=";
                  end = "=#";
                };
                language-servers = [ "julia" ];
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
              }
              # {
              #   name = "just";
              #   scope = "source.just";
              #   file-types = [
              #     "just"
              #     { glob = "justfile"; }
              #     { glob = "Justfile"; }
              #     { glob = ".justfile"; }
              #     { glob = ".Justfile"; }
              #   ];
              #   injection-regex = "just";
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "just-lsp" ];
              #   auto-format = true;
              #   formatter = {
              #     command = "${just}/bin/just";
              #     args = [ "--dump" ];
              #   };
              # }
              {
                name = "json";
                scope = "source.json";
                injection-regex = "json";
                file-types = [
                  "arb"
                  "avsc"
                  "css.map"
                  "geojson"
                  "gltf"
                  "ipynb"
                  "js.map"
                  "json"
                  "jsonl"
                  "jsonld"
                  "ldtk"
                  "ldtkl"
                  "sublime-build"
                  "sublime-color-scheme"
                  "sublime-commands"
                  "sublime-completions"
                  "sublime-keymap"
                  "sublime-macro"
                  "sublime-menu"
                  "sublime-mousemap"
                  "sublime-project"
                  "sublime-settings"
                  "sublime-theme"
                  "sublime-workspace"
                  "ts.map"
                  "webmanifest"
                  { glob = ".babelrc"; }
                  { glob = ".bowerrc"; }
                  { glob = ".jscrc"; }
                  { glob = ".jslintrc"; }
                  { glob = ".swift-format"; }
                  { glob = ".vuerc"; }
                  { glob = ".watchmanconfig"; }
                  { glob = "composer.lock"; }
                  { glob = "flake.lock"; }
                ];
                language-servers = [ "vscode-json-language-server" ];
                auto-format = true;
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              {
                name = "jsonc";
                scope = "source.json";
                injection-regex = "jsonc";
                file-types = [
                  "jsonc"
                  { glob = "tsconfig.json"; }
                  { glob = "bun.lock"; }
                ];
                comment-token = "//";
                block-comment-tokens = {
                  start = "/*";
                  end = "*/";
                };
                grammar = "json";
                language-servers = [ "vscode-json-language-server" ];
                auto-format = true;
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              # {
              #   name = "jsonnet";
              #   scope = "source.jsonnet";
              #   file-types = [
              #     "libsonnet"
              #     "jsonnet"
              #   ];
              #   roots = [ "jsonnetfile.json" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "jsonnet-language-server" ];
              # }
              # {
              #   name = "json5";
              #   scope = "source.json5";
              #   injection-regex = "json5";
              #   file-types = [ "json5" ];
              #   language-servers = [];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "jsx";
              #   scope = "source.jsx";
              #   injection-regex = "jsx";
              #   language-id = "javascriptreact";
              #   file-types = [ "jsx" ];
              #   roots = [ "package.json" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "typescript-language-server" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "javascript";
              # }
              # {
              #   name = "kconfig";
              #   file-types = [
              #     "kconfig"
              #     { glob = "kconfig.*"; }
              #   ];
              #   scope = "source.kconfig";
              # }
              # {
              #   name = "kdl";
              #   scope = "source.kdl";
              #   file-types = [ "kdl" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   injection-regex = "kdl";
              #   formatter = {
              #     command = "${kdlfmt}/bin/kdlfmt";
              #     args = ["format" "-"];
              #   };
              # }
              # {
              #   name = "koka";
              #   scope = "source.koka";
              #   injection-regex = "koka";
              #   file-types = [ "kk" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 8;
              #     unit = "  ";
              #   };
              #   language-servers = [ "koka" ];
              # }
              # {
              #   name = "kotlin";
              #   scope = "source.kotlin";
              #   file-types = [
              #     "kt" "kts"
              #   ];
              #   roots = [
              #     "settings.gradle" "settings.gradle.kts"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [
              #     "kotlin-language-server"
              #   ];
              # }
              # {
              #   name = "koto";
              #   scope = "source.koto";
              #   injection-regex = "koto";
              #   file-types = [ "koto" ];
              #   comment-token = "#";
              #   block-comment-tokens = [
              #     "#-" "-#"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "koto-ls" ];
              #   formatter = {
              #     command = "${koto}/bin/koto";
              #     args = [ "--format" ];
              #   };
              # }
              {
                name = "latex";
                scope = "source.tex";
                injection-regex = "tex";
                file-types = [ "tex" "sty" "cls" "Rd" "bbx" "cbx" ];
                comment-token = "%";
                language-servers = [ "texlab" ];
                indent = {
                  tab-width = 4;
                  unit = "\t";
                };
              }
              # {
              #   name = "ld";
              #   scope = "source.ld";
              #   injection-regex = "ld";
              #   file-types = [ "ld" ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "ldif";
              #   scope = "source.ldif";
              #   injection-regex = "ldif";
              #   file-types = [ "ldif" ];
              #   comment-token = "#";
              # }
              # {
              #   name = "lean";
              #   scope = "source.lean";
              #   injection-regex = "lean";
              #   file-types = [ "lean" ];
              #   roots = [ "lakefile.lean" ];
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "/-";
              #     end = "-/";
              #   };
              #   language-servers = [ "lean" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "ledger";
              #   scope = "source.ledger";
              #   injection-regex = "ledger";
              #   file-types = [ "ldg" "ledger" "journal" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "llvm";
              #   scope = "source.llvm";
              #   file-types = [ "ll" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   injection-regex = "llvm";
              # }
              # {
              #   name = "llvm-mir";
              #   scope = "source.llvm_mir";
              #   file-types = [];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   injection-regex = "mir";
              # }
              # {
              #   name = "llvm-mir-yaml";
              #   scope = "source.yaml";
              #   file-types = [ "mir" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "log";
              #   scope = "source.log";
              #   file-types = [ "log" ];
              # }
              # {
              #   name = "lua";
              #   injection-regex = "lua";
              #   scope = "source.lua";
              #   file-types = [ "lua" ];
              #   shebangs = [ "lua" "luajit" ];
              #   roots = [
              #     ".git"
              #     ".luacheckrc"
              #     ".luarc.json"
              #     ".stylua.toml"
              #     "selene.toml"
              #   ];
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "--[[";
              #     end = "--]]";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [
              #     "lua-language-server"
              #   ];
              # }
              # {
              #   name = "luap";
              #   scope = "source.luap";
              #   file-types = [];
              #   injection-regex = "luap";
              # }
              # {
              #   name = "luau";
              #   scope = "source.luau";
              #   injection-regex = "^luau$";
              #   file-types = [ "luau" ];
              #   comment-tokens = [ "--" "---" ];
              #   block-comment-tokens = [
              #     {
              #       start = "--[[";
              #       end = "]]";
              #     }
              #     {
              #       start = "--[=[";
              #       end = "]=]";
              #     }
              #     {
              #       start = "--[==[";
              #       end = "]==]";
              #     }
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   roots = [
              #     ".darklua.json"
              #     ".luaurc"
              #     "aftman.toml"
              #     "default.project.json"
              #     "foreman.toml"
              #     "rokit.toml"
              #     "selene.toml"
              #     "wally.toml"
              #   ];
              #   language-servers = [ "luau" ];
              # }
              # {
              #   name = "lpf";
              #   comment-token = "#";
              #   scope = "source.lpf";
              #   file-types = [ "lpf" ];
              # }
              # {
              #   name = "mail";
              #   scope = "text.mail";
              #   file-types = [ "eml" ];
              #   injection-regex = "mail|eml|email";
              #   language-servers = [
              #   ];
              # }
              # {
              #   name = "make";
              #   scope = "source.make";
              #   file-types = [
              #     "mak" "make" "mk"
              #     { glob = "GNUmakefile"; }
              #     { glob = "Makefile"; }
              #     { glob = "OCamlMakefile"; }
              #     { glob = "makefile"; }
              #   ];
              #   shebangs = [ "make" "gmake" ];
              #   injection-regex = "(make|makefile|Makefile|mk)";
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              {
                name = "matlab";
                scope = "source.m";
                file-types = [ "m" ];
                comment-token = "%";
                shebangs = [
                  "octave-cli"
                  "matlab"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              {
                name = "markdown";
                scope = "source.md";
                injection-regex = "md|markdown";
                file-types = [
                  "md" "markdown" "mkd" "mkdn" "mdwn" "mdown" "markdn"
                  "mdtxt" "mdtext" "workbook"
                  { glob = "PULLREQ_EDITMSG"; }
                ];
                roots = [ ".marksman.toml" ];
                language-servers = [
                  "typos-lsp"
                  "markdown-oxide"
                  "marksman"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                block-comment-tokens = {
                  start = "<!--";
                  end = "-->";
                };
                grammar = "markdown";
              }
              {
                name = "markdown-rustdoc";
                scope = "source.markdown-rustdoc";
                grammar = "markdown";
                injection-regex = "markdown-rustdoc";
                file-types = [];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                block-comment-tokens = {
                  start = "<!--";
                  end = "-->";
                };
              }
              {
                name = "markdown.inline";
                scope = "source.markdown.inline";
                injection-regex = "markdown\\.inline";
                file-types = [];
                grammar = "markdown_inline";
              }
              {
                name = "mermaid";
                scope = "source.mermaid";
                injection-regex = "mermaid";
                file-types = [
                  "mermaid" "mmd"
                ];
                comment-token = "%%";
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
              }
              # {
              #   name = "meson";
              #   scope = "source.meson";
              #   injection-regex = "meson";
              #   file-types = [
              #     { glob = "meson.build"; }
              #     { glob = "meson.options"; }
              #     { glob = "meson_options.txt"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "mint";
              #   scope = "source.mint";
              #   injection-regex = "mint";
              #   file-types = [ "mint" ];
              #   shebangs = [];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "mint" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "mojo";
              #   scope = "source.mojo";
              #   roots = [ "pixi.toml" "pixi.lock" ];
              #   injection-regex = "mojo";
              #   file-types = [ "mojo" "🔥" ];
              #   language-servers = [ "mojo-lsp-server" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-format = true;
              #   formatter = {
              #     command = "${pixi}/bin/pixi";
              #     args = [ "run" "mojo"  "format" "-q" "-" ];
              #   };
              # }
              # {
              #   name = "move";
              #   scope = "source.move";
              #   injection-regex = "move";
              #   roots = [ "Move.toml" ];
              #   file-types = [ "move" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [];
              # }
              # {
              #   name = "msbuild";
              #   scope = "source.msbuild";
              #   injection-regex = "msbuild";
              #   file-types = [
              #     "proj"
              #     "vbproj"
              #     "csproj"
              #     "fsproj"
              #     "targets"
              #     "props"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   grammar = "xml";
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #     "'" = "'";
              #     "<" = ">";
              #   };
              # }
              # {
              #   name = "nasm";
              #   scope = "source.nasm";
              #   file-types = [ "asm" "S" "nasm" ];
              #   injection-regex = "n?asm";
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 8;
              #     unit = "        ";
              #   };
              #   language-servers = [ "asm-lsp" ];
              # }
              # {
              #   name = "nestedtext";
              #   scope = "text.nested";
              #   injection-regex = "nestedtext";
              #   file-types = [ "nt" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   grammar = "yaml";
              # }
              # {
              #   name = "nginx";
              #   scope = "source.nginx";
              #   injection-regex = "nginx";
              #   file-types = [
              #     { glob = "sites-available/*.conf"; }
              #     { glob = "sites-enabled/*.conf"; }
              #     { glob = "nginx.conf"; }
              #     { glob = "conf.d/*.conf"; }
              #   ];
              #   roots = [ "nginx.conf" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "nim";
              #   scope = "source.nim";
              #   injection-regex = "nim";
              #   file-types = [ "nim" "nims" "nimble" ];
              #   shebangs = [];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "#[";
              #     end = "]#";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "nimlangserver" ];
              #   auto-pairs = {
              #     "(" = ")";
              #     "[" = "]";
              #     "\"" = "\"";
              #     "'" = "'";
              #     "{" = "}";
              #   };
              # }
              # {
              #   name = "nickel";
              #   scope = "source.nickel";
              #   injection-regex = "nickel";
              #   file-types = [ "ncl" ];
              #   shebangs = [];
              #   comment-token = "#";
              #   language-servers = [ "nls" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              {
                name = "nix";
                scope = "source.nix";
                injection-regex = "nix";
                file-types = [ "nix" ];
                shebangs = [];
                comment-token = "#";
                language-servers = [
                  "nil"
                  "nixd"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                formatter = {
                  command = "${nixfmt-rfc-style}/bin/nixfmt";
                };
              }
              # {
              #   name = "nu";
              #   scope = "source.nu";
              #   injection-regex = "nu";
              #   file-types = [
              #     "nu" "nuon"
              #   ];
              #   shebangs = [ "nu" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "nu-lsp" ];
              # }
              # {
              #   name = "nunjucks";
              #   scope = "text.html.nunjucks";
              #   injection-regex = "nunjucks";
              #   file-types = [ "njk" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "jinja2";
              #   block-comment-tokens = {
              #     start = "{#";
              #     end = "#}";
              #   };
              # }
              # {
              #   name = "ocaml";
              #   scope = "source.ocaml";
              #   injection-regex = "ocaml";
              #   file-types = [ "ml" ];
              #   shebangs = [ "ocaml" "ocamlrun" "ocamlscript" ];
              #   block-comment-tokens = {
              #     start = "(*";
              #     end = "*)";
              #   };
              #   language-servers = [ "ocamllsp" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "ocaml-interface";
              #   scope = "source.ocaml.interface";
              #   file-types = [ "mli" ];
              #   shebangs = [];
              #   block-comment-tokens = {
              #     start = "(*";
              #     end = "*)";
              #   };
              #   comment-token = "(**)";
              #   language-servers = [ "ocamllsp" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "odin";
              #   auto-format = true;
              #   scope = "source.odin";
              #   file-types = [ "odin" ];
              #   roots = [ "ols.json" "main.odin" ];
              #   language-servers = [ "ols" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   formatter = {
              #     command = "${ols}/bin/odinfmt";
              #     args = [ "-stdin" "true" ];
              #   };
              #   debugger = {
              #     name = "lldb-dap";
              #     transport = "stdio";
              #     command = "${lldb}/bin/lldb-dap";
              #     templates = [
              #       {
              #         name = "binary";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           console = "internalConsole";
              #           pid = "{0}";
              #         };
              #       }
              #       {
              #         name = "gdbserver attach";
              #         request = "attach";
              #         completion = [
              #           {
              #             name = "lldb connect url";
              #             default = "connect://localhost:3333";
              #           }
              #           {
              #             name = "file";
              #             completion = "filename";
              #           }
              #           "pid"
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           attachCommands = [
              #             "platform select remote-gdb-server"
              #             "platform connect {0}"
              #             "file {1}"
              #             "attach {2}"
              #           ];
              #         };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "ohm";
              #   scope = "source.ohm";
              #   injection-regex = "ohm";
              #   file-types = [ "ohm" ];
              #   comment-token = "//";
              #   block-comment-tokens = [
              #     { start = "/*"; end = "*/"; }
              #     { start = "/**"; end = "*/"; }
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #   "\"" = "\"";
              #   "{" = "}";
              #   "(" = ")";
              #   "<" = ">";
              #   };
              # }
              # {
              #   name = "opencl";
              #   scope = "source.cl";
              #   injection-regex = "(cl|opencl)";
              #   file-types = [ "cl" ];
              #   comment-token = "//";
              #   language-servers = [ "clangd" ];
              # }
              # {
              #   name = "openscad";
              #   scope = "source.openscad";
              #   injection-regex = "openscad";
              #   file-types = [ "scad" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "openscad-lsp" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "org";
              #   scope = "source.org";
              #   injection-regex = "org";
              #   file-types = [ "org" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "passwd";
              #   scope = "source.passwd";
              #   file-types = [
              #     { glob = "passwd"; }
              #   ];
              # }
              # {
              #   name = "perl";
              #   scope = "source.perl";
              #   file-types = [
              #     "pl"
              #     "pm"
              #     "t"
              #     "psgi"
              #     "raku"
              #     "rakumod"
              #     "rakutest"
              #     "rakudoc"
              #     "nqp"
              #     "p6"
              #     "pl6"
              #     "pm6"
              #   ];
              #   shebangs = [ "perl" ];
              #   comment-token = "#";
              #   language-servers = [ "perlnavigator" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "pem";
              #   scope = "source.pem";
              #   file-types = [
              #     "pem" "cert" "crt"
              #   ];
              #   injection-regex = "pem";
              #   grammar = "pem";
              # }
              # {
              #   name = "pest";
              #   scope = "source.pest";
              #   injection-regex = "pest";
              #   file-types = [ "pest" ];
              #   comment-tokens = [
              #     "//" "///" "//!"
              #   ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #     };
              #   language-servers = [ "pest-language-server" ];
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "php";
              #   scope = "source.php";
              #   injection-regex = "php";
              #   file-types = [ "php" "inc" "php4" "php5" "phtml" "ctp" ];
              #   shebangs = [ "php" ];
              #   roots = [ "composer.json" "index.php" ];
              #   comment-token = "//";
              #   block-comment-tokens = [
              #     {start = "/**"; end = "*/";}
              #     {start = "/*"; end = "*/";}
              #   ];
              #   language-servers = [
              #     "phpactor"
              #   ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "php-only";
              #   scope = "source.php-only";
              #   injection-regex = "php-only";
              #   file-types = [];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    "; };
              #   roots = [
              #     "composer.json"
              #     "index.php"
              #   ];
              # }
              # {
              #   name = "pip-requirements";
              #   scope = "source.pip-requirements";
              #   injection-regex = "(pip-)?requirements(\\.txt)?";
              #   grammar = "requirements";
              #   file-types = [
              #     { glob = "requirements.txt"; }
              #     { glob = "constraints.txt"; }
              #   ];
              # }
              # {
              #   name = "po";
              #   scope = "source.po";
              #   file-types = [ "po" "pot" ];
              #   comment-token = "#";
              # }
              # {
              #   name = "pod";
              #   scope = "source.pod";
              #   injection-regex = "pod";
              #   file-types = [ "pod" ];
              # }
              # {
              #   name = "ponylang";
              #   scope = "source.pony";
              #   file-types = [ "pony" ];
              #   injection-regex = "pony";
              #   roots = [
              #     "corral.json"
              #     "lock.json"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/";
              #     end = "*/";
              #   };
              # }
              # {
              #   name = "powershell";
              #   scope = "source.powershell";
              #   injection-regex = "(pwsh|powershell)";
              #   file-types = [ "ps1" "psm1" "psd1" "pscc" "psrc" ];
              #   shebangs = [ "pwsh" "powershell" ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "<#";
              #     end = "#>";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "prisma";
              #   scope = "source.prisma";
              #   injection-regex = "prisma";
              #   file-types = [ "prisma" ];
              #   roots = [ "package.json" ];
              #   comment-token = "//";
              #   language-servers = [ "prisma-language-server" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "prolog";
              #   scope = "source.prolog";
              #   file-types = [
              #     "pl" "prolog"
              #   ];
              #   shebangs = [ "swipl" ];
              #   comment-token = "%";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "swipl" ];
              # }
              # {
              #   name = "properties";
              #   scope = "source.properties";
              #   injection-regex = "properties";
              #   file-types = [ "properties" "prefs" ];
              #   comment-tokens = [ "#" ];
              # }
              # {
              #   name = "protobuf";
              #   scope = "source.proto";
              #   injection-regex = "protobuf";
              #   file-types = [ "proto" ];
              #   language-servers = [ "buf" "pbkit" "protols" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "proto";
              # }
              # {
              #   name = "prql";
              #   scope = "source.prql";
              #   injection-regex = "prql";
              #   file-types = [ "prql" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "pug";
              #   scope = "source.pug";
              #   file-types = [ "pug" ];
              #   comment-tokens = [ "//" "//-" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "purescript";
              #   scope = "source.purescript";
              #   injection-regex = "purescript";
              #   file-types = [ "purs" ];
              #   roots = [
              #     "spago.yaml" "spago.dhall" "bower.json"
              #   ];
              #   comment-token = "--";
              #   block-comment-tokens = {
              #     start = "{-";
              #     end = "-}";
              #   };
              #   language-servers = [
              #     "purescript-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-format = true;
              #   formatter = with nodePackages; {
              #     command = "${purs-tidy}/bin/purs-tidy";
              #     args = [ "format" ];
              #   };
              # }
              {
                name = "python";
                scope = "source.python";
                injection-regex = "py(thon)?";
                file-types = [
                  "cpy" "ipy" "ptl" "py" "py3" "pyi" "pyt" "pyw" "rpy"
                  { glob = "*sconstruct"; }
                  { glob = ".python_history"; }
                  { glob = ".pythonrc"; }
                  { glob = ".pythonstartup"; }
                  { glob = "SConscript"; }
                  { glob = "SConstruct"; }
                ];
                shebangs = [ "python" "uv" ];
                roots = [
                  "poetry.lock"
                  "pyproject.toml"
                  "pyrightconfig.json"
                  "setup.py"
                ];
                comment-token = "#";
                language-servers = [
                  "ty"
                  "ruff"
                  "jedi"
                  "pylsp"
                ];
                auto-format = true;
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
                formatter = {
                  command = "${python_list.python_pkgs}/bin/black";
                  args = [ "--line-length" "88" "--quiet" "-" ];
                };
              }
              # {
              #   name = "qml";
              #   scope = "source.qml";
              #   file-types = [ "qml" ];
              #   language-servers = [ "qmlls" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   grammar = "qmljs";
              # }
              {
                name = "quarto";
                scope = "source.qmd";
                language-id = "qmd";
                injection-regex = "qmd";
                file-types = [ "qmd" ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                grammar = "markdown";
                block-comment-tokens = {
                  start = "<!--";
                  end = "-->";
                };
                language-servers = [
                  "typos-lsp"
                  "markdown-oxide"
                  "marksman"
                ];
              }
              {
                name = "r";
                scope = "source.r";
                injection-regex = "(r|R)";
                file-types = [
                  "r" "R"
                  { glob = ".Rprofile"; }
                  { glob = "Rprofile.site"; }
                  { glob = ".RHistory"; }
                ];
                shebangs = [ "r" "R" ];
                comment-tokens = [
                  "#" "#'"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                language-servers = [ "r" ];
              }
              # {
              #   name = "racket";
              #   scope = "source.racket";
              #   file-types = [ "rkt" "rktd" "rktl" "scrbl" ];
              #   shebangs = [ "racket" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   block-comment-tokens = {
              #     start = "#|";
              #     end = "|#";
              #   };
              #   language-servers = [ "racket" ];
              #   grammar = "scheme";
              # }
              {
                name = "regex";
                scope = "source.regex";
                injection-regex = "regex";
                file-types = [
                  "regex"
                  { glob = ".Rbuildignore"; }
                ];
              }
              # {
              #   name = "rego";
              #   scope = "source.rego";
              #   injection-regex = "rego";
              #   file-types = [ "rego" ];
              #   auto-format = true;
              #   comment-token = "#";
              #   language-servers = [ "regols" ];
              #   grammar = "rego";
              # }
              # {
              #   name = "rmarkdown";
              #   scope = "source.rmd";
              #   language-id = "rmd";
              #   injection-regex = "(r|R)md";
              #   file-types = [ "rmd" "Rmd" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "r" ];
              # }
              # {
              #   name = "robots.txt";
              #   scope = "source.robots.txt";
              #   file-types = [
              #     { glob = "robots.txt"; }
              #   ];
              #   injection-regex = "robots[\\.-]txt";
              #   grammar = "robots";
              #   comment-token = "#";
              # }
              # {
              #   name = "ron";
              #   scope = "source.ron";
              #   injection-regex = "ron";
              #   file-types = [ "ron" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "ruby";
              #   scope = "source.ruby";
              #   injection-regex = "ruby";
              #   file-types = [
              #     "rb"
              #     "rake"
              #     "irb"
              #     "gemspec"
              #     "rabl"
              #     "jbuilder"
              #     "jb"
              #     "podspec"
              #     "rjs"
              #     "rbi"
              #     { glob = "rakefile"; }
              #     { glob = "gemfile"; }
              #     { glob = "Rakefile"; }
              #     { glob = "Gemfile"; }
              #     { glob = "Podfile"; }
              #     { glob = "Vagrantfile"; }
              #     { glob = "Brewfile"; }
              #     { glob = "Guardfile"; }
              #     { glob = "Capfile"; }
              #     { glob = "Cheffile"; }
              #     { glob = "Hobofile"; }
              #     { glob = "Appraisals"; }
              #     { glob = "Rantfile"; }
              #     { glob = "Berksfile"; }
              #     { glob = "Berksfile.lock"; }
              #     { glob = "Thorfile"; }
              #     { glob = "Puppetfile"; }
              #     { glob = "Fastfile"; }
              #     { glob = "Appfile"; }
              #     { glob = "Deliverfile"; }
              #     { glob = "Matchfile"; }
              #     { glob = "Scanfile"; }
              #     { glob = "Snapfile"; }
              #     { glob = "Gymfile"; }
              #   ];
              #   shebangs = [ "ruby" ];
              #   comment-token = "#";
              #   language-servers = [ "ruby-lsp" "solargraph" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              {
                name = "rust";
                scope = "source.rust";
                injection-regex = "rs|rust";
                file-types = [ "rs" ];
                roots = [ "Cargo.toml" "Cargo.lock" ];
                shebangs = [ "rust-script" "cargo" ];
                auto-format = true;
                comment-tokens = [ "//" "///" "//!" ];
                block-comment-tokens = [
                  { start = "/*"; end = "*/"; }
                  { start = "/**"; end = "*/"; }
                  { start = "/*!"; end = "*/"; }
                ];
                language-servers = [
                  "rust-analyzer"
                ];
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
                persistent-diagnostic-sources = [ "rustc" "clippy" ];
                debugger = {
                  name = "lldb-dap";
                  transport = "stdio";
                  command = "${lldb}/bin/lldb-dap";
                  templates = [
                    {
                      name = "binary";
                      request = "launch";
                      completion = [
                        {
                          name = "binary";
                          completion = "filename";
                        }
                      ];
                      args = {
                        program = "{0}";
                      };
                    }
                    {
                      name = "binary (terminal)";
                      request = "launch";
                      completion = [
                        {
                          name = "binary";
                          completion = "filename";
                        }
                      ];
                      args = {
                        program = "{0}";
                        runInTerminal = true;
                      };
                    }
                    {
                      name = "attach";
                      request = "attach";
                      completion = [ "pid" ];
                      args = { pid = "{0}"; };
                    }
                    {
                      name = "gdbserver attach";
                      request = "attach";
                      completion = [
                        {
                          name = "lldb connect url";
                          default = "connect://localhost:3333";
                        }
                        {
                          name = "file";
                          completion = "filename";
                        }
                        "pid"
                      ];
                      args = {
                        attachCommands = [
                          "platform select remote-gdb-server"
                          "platform connect {0}"
                          "file {1}"
                          "attach {2}"
                        ];
                      };
                    }
                  ];
                };
              }
              {
                name = "rust-format-args";
                scope = "source.rust-format-args";
                file-types = [];
                injection-regex = "rust-format-args";
              }
              {
                name = "rust-format-args-macro";
                scope = "source.rust-format-args-macro";
                file-types = [];
                grammar = "rust";
              }
              {
                name = "rst";
                scope = "source.rst";
                comment-token = "..";
                file-types = [ "rst" ];
              }
              # {
              #   name = "sage";
              #   scope = "source.sage";
              #   file-types = [ "sage" ];
              #   injection-regex = "sage";
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   grammar = "python";
              # }
              # {
              #   name = "scheme";
              #   scope = "source.scheme";
              #   injection-regex = "scheme";
              #   file-types = [ "ss" "scm" "sld" ];
              #   shebangs = [ "scheme" "guile" "chicken" ];
              #   comment-token = ";";
              #   block-comment-tokens = {
              #     start = "#|";
              #     end = "|#";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              {
                name = "scala";
                scope = "source.scala";
                roots = [
                  "build.sbt"
                  "build.sc"
                  "build.gradle"
                  "build.gradle.kts"
                  "pom.xml"
                  ".scala-build"
                ];
                file-types = [ "scala" "sbt" "sc" ];
                comment-token = "//";
                block-comment-tokens = {
                  start = "/*";
                  end = "*/";
                };
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                language-servers = [
                  "metals"
                ];
              }
              # {
              #   name = "scss";
              #   scope = "source.scss";
              #   injection-regex = "scss";
              #   file-types = [ "scss" ];
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "vscode-css-language-server" ];
              #   auto-format = true;
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "slint";
              #   scope = "source.slint";
              #   injection-regex = "slint";
              #   file-types = [ "slint" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [ "slint-lsp" ];
              # }
              # {
              #   name = "shellcheckrc";
              #   scope = "source.shellcheckrc";
              #   injection-regex = "shellcheck(rc)?";
              #   file-types = [
              #     {glob = "shellcheckrc";}
              #     {glob = ".shellcheckrc";}
              #   ];
              #   comment-token = "#";
              # }
              # {
              #   name = "slisp";
              #   scope = "source.sl";
              #   injection-regex = "sl";
              #   file-types = [ "sl" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "smali";
              #   scope = "source.smali";
              #   injection-regex = "smali";
              #   file-types = [ "smali" ];
              #   comment-token = "#";
              #   roots = [];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "sml";
              #   scope = "source.sml";
              #   injection-regex = "sml";
              #   file-types = [ "sml" ];
              #   block-comment-tokens = {
              #     start = "(*";
              #     end = "*)";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #   };
              # }
              # {
              #   name = "snakemake";
              #   scope = "source.snakemake";
              #   roots = [ "Snakefile" "config.yaml" "environment.yaml" "workflow/" ];
              #   file-types = [
              #     "smk"
              #     { glob = "Snakefile"; }
              #   ];
              #   comment-tokens = [ "#" "##" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "pylsp" ];
              #   formatter = {
              #     command = "${snakefmt}/bin/snakefmt";
              #     args = [ "-" ];
              #   };
              # }
              # {
              #   name = "solidity";
              #   scope = "source.sol";
              #   injection-regex = "(sol|solidity)";
              #   file-types = [ "sol" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   language-servers = [
              #     "solc"
              #   ];
              # }
              # {
              #   name = "sourcepawn";
              #   scope = "source.sourcepawn";
              #   file-types = [
              #     "sp" "inc"
              #   ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "  ";
              #   };
              #   language-servers = [ "sourcepawn-studio" ];
              # }
              # {
              #   name = "spade";
              #   scope = "source.spade";
              #   roots = [ "swim.toml" ];
              #   file-types = [ "spade" ];
              #   injection-regex = "spade";
              #   comment-tokens = [
              #     "//" "///"
              #   ];
              #   block-comment-tokens = [
              #     {
              #       start = "/*";
              #       end = "*/";
              #     }
              #     {
              #       start = "/**";
              #       end = "*/";
              #     }
              #   ];
              #   language-servers = [ "spade-language-server" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-pairs = {
              #   "\"" = "\"";
              #   "{" = "}";
              #   "(" = ")";
              #   "<" = ">";
              #   "[" = "]";
              #   };
              # }
              # {
              #   name = "spicedb";
              #   scope = "source.zed";
              #   injection-regex = "spicedb";
              #   file-types = [ "zed" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              {
                name = "sql";
                scope = "source.sql";
                file-types = [ "sql" "dsql" ];
                comment-token = "--";
                block-comment-tokens = {
                  start = "/*";
                  end = "*/";
                };
                indent = {
                  tab-width = 4;
                  unit = "    ";
                };
                language-servers = [ "sqls" ];
                injection-regex = "sql";
              }
              # {
              #   name = "sshclientconfig";
              #   scope = "source.sshclientconfig";
              #   file-types = [
              #     { glob = ".ssh/config"; }
              #     { glob = "/etc/ssh/ssh_config"; }
              #     { glob = "ssh_config.d/*.conf"; }
              #   ];
              #   comment-token = "#";
              # }
              # {
              #   name = "starlark";
              #   scope = "source.starlark";
              #   injection-regex = "(starlark|bzl|bazel|buck)";
              #   language-servers = [ "starpls" ];
              #   file-types = [
              #     "bzl"
              #     "bazel"
              #     "star"
              #     { glob = "BUCK"; }
              #     { glob = "BUILD"; }
              #     { glob = "BUILD.*"; }
              #     { glob = "PACKAGE"; }
              #     { glob = "Tiltfile"; }
              #     { glob = "WORKSPACE"; }
              #     { glob = "WORKSPACE.bzlmod"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   grammar = "python";
              # }
              # {
              #   name = "strace";
              #   scope = "source.strace";
              #   file-types = [ "strace" ];
              # }
              # {
              #   name = "strictdoc";
              #   scope = "source.strictdoc";
              #   injection-regex = "strictdoc";
              #   file-types = [ "sdoc" "sgra" ];
              #   comment-token = "..";
              # }
              # {
              #   name = "supercollider";
              #   scope = "source.supercollider";
              #   injection-regex = "supercollider";
              #   file-types = [ "scd" "sc" "quark" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              # }
              # {
              #   name = "svelte";
              #   scope = "source.svelte";
              #   injection-regex = "svelte";
              #   file-types = [ "svelte" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "svelteserver" ];
              # }
              # {
              #   name = "systemverilog";
              #   scope = "source.systemverilog";
              #   file-types = [ "sv" "svh" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "verible-verilog-ls" ];
              # }
              # {
              #   name = "systemd";
              #   scope = "source.ini";
              #   file-types = [
              #     # Systemd unit files;
              #     "service"
              #     "automount"
              #     "device"
              #     "mount"
              #     "nspawn"
              #     "path"
              #     "scope"
              #     "slice"
              #     "socket"
              #     "swap"
              #     "target"
              #     "timer"
              #     { glob = "systemd/**/*.conf"; }
              #   ];
              #   injection-regex = "systemd";
              #   comment-token = "#";
              #   grammar = "ini";
              #   language-servers = [ "systemd-lsp" ];
              # }
              # {
              #   name = "t32";
              #   scope = "source.t32";
              #   injection-regex = "t32";
              #   file-types = [ "cmm" "t32" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "tablegen";
              #   scope = "source.tablegen";
              #   file-types = [ "td" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   injection-regex = "tablegen";
              # }
              # {
              #   name = "tact";
              #   scope = "source.tact";
              #   injection-regex = "tact";
              #   file-types = [ "tact" ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-pairs = {
              #   "\"" = "\"";
              #   "{" = "}";
              #   "(" = ")";
              #   "<" = ">";
              #   };
              # }
              # {
              #   name = "task";
              #   scope = "source.task";
              #   injection-regex = "task";
              #   file-types = [ "task" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "tcl";
              #   scope = "source.tcl";
              #   injection-regex = "tcl";
              #   file-types = [ "tcl" ];
              #   shebangs = [ "tclsh" "tclish" "jimsh" "wish" ];
              #   comment-token = "#";
              # }
              # {
              #   name = "teal";
              #   scope = "source.tl";
              #   injection-regex = "teal";
              #   file-types = [ "tl" ];
              #   comment-tokens = "--";
              #   block-comment-tokens = {
              #     start = "--[[";
              #     end = "--]]";
              #   };
              #   roots = [ "tlconfig.lua" ];
              #   language-servers = [ "teal-language-server" ];
              # }
              # {
              #   name = "templ";
              #   scope = "source.templ";
              #   file-types = [ "templ" ];
              #   roots = [
              #     "go.work"
              #     "go.mod"
              #   ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "templ" ];
              # }
              # {
              #   name = "tera";
              #   scope = "source.tera";
              #   file-types = [ "tera" ];
              #   block-comment-tokens = [
              #     { start = "{#"; end = "#}"; }
              #     { start = "{#-"; end = "-#}"; }
              #     { start = "{#"; end = "-#}"; }
              #     { start = "{#-"; end = "#}"; }
              #   ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "textproto";
              #   file-types = [
              #     "txtpb"
              #     "textpb"
              #     "textproto"
              #   ];
              #   comment-token = "#";
              #   scope = "source.textproto";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   formatter = {
              #     command = "${txtpbfmt}/bin/txtpbfmt";
              #   };
              #   auto-format = true;
              # }
              # {
              #   name = "tfvars";
              #   scope = "source.tfvars";
              #   language-id = "terraform-vars";
              #   file-types = [ "tfvars" ];
              #   comment-token = "#";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "terraform-ls" ];
              #   auto-format = true;
              #   grammar = "hcl";
              # }
              # {
              #   name = "thrift";
              #   scope = "source.thrift";
              #   file-types = [ "thrift" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "tlaplus";
              #   scope = "scope.tlaplus";
              #   injection-regex = "tla";
              #   file-types = [
              #     "tla"
              #   ];
              #   comment-tokens = "\\*";
              #   block-comment-tokens = {
              #     start = "(*";
              #     end="*)";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = " ";
              #   };
              #   formatter = {
              #     command = "${tlafmt}/bin/tlafmt";
              #     args = [ "--stdin" ];
              #   };
              # }
              # {
              #   name = "todotxt";
              #   scope = "text.todotxt";
              #   file-types = [
              #     "todotxt"
              #     { glob = "*.todo.txt"; }
              #   ];
              #   formatter = {
              #     command = "${coreutils-full}/bin/sort";
              #   };
              #   auto-format = true;
              # }
              {
                name = "toml";
                scope = "source.toml";
                injection-regex = "toml";
                file-types = [
                  "toml"
                  { glob = "Cargo.lock"; }
                  { glob = "containers.conf"; }
                  { glob = "containers.conf.d/*.conf"; }
                  { glob = "containers.conf.modules/*.conf"; }
                  { glob = "mounts.conf"; }
                  { glob = "pdm.lock"; }
                  { glob = "poetry.lock"; }
                  { glob = "policy.conf"; }
                  { glob = "registries.conf"; }
                  { glob = "storage.conf"; }
                  { glob = "uv.lock"; }
                ];
                comment-token = "#";
                language-servers = [
                  "taplo"
                  "tombi"
                ];
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
              }
              # {
              #   name = "tsq";
              #   scope = "source.tsq";
              #   file-types = [
              #     { glob = "highlights.scm"; }
              #     { glob = "indents.scm"; }
              #     { glob = "injections.scm"; }
              #     { glob = "locals.scm"; }
              #     { glob = "queries/*.scm"; }
              #     { glob = "tags.scm"; }
              #     { glob = "textobjects.scm"; }
              #   ];
              #   comment-token = ";";
              #   injection-regex = "tsq";
              #   language-servers = [ "ts_query_ls" ];
              #   grammar = "query";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "tsx";
              #   scope = "source.tsx";
              #   injection-regex = "(tsx)";
              #   language-id = "typescriptreact";
              #   file-types = [ "tsx" ];
              #   roots = [
              #     "package.json"
              #     "tsconfig.json"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "typescript-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "twig";
              #   scope = "source.twig";
              #   injection-regex = "twig";
              #   file-types = [ "twig" ];
              #   block-comment-tokens = {
              #     start = "{#";
              #     end = "#}";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "typescript";
              #   scope = "source.ts";
              #   injection-regex = "(ts|typescript)";
              #   language-id = "typescript";
              #   file-types = [ "ts" "mts" "cts" ];
              #   shebangs = [ "deno" "bun" "ts-node" ];
              #   roots = [ "package.json" "tsconfig.json" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "typescript-language-server"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "typespec";
              #   scope = "source.typespec";
              #   injection-regex = "(tsp|typespec)";
              #   language-id = "typespec";
              #   file-types = [ "tsp" ];
              #   roots = [ "tspconfig.yaml" ];
              #   auto-format = true;
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "typespec" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "typst";
              #   scope = "source.typst";
              #   injection-regex = "typ(st)?";
              #   file-types = [
              #     "typst"
              #     "typ"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [
              #     "tinymist"
              #   ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #   "(" = ")";
              #   "{" = "}";
              #   "[" = "]";
              #   "$" = "$";
              #   "\"" = "\"";
              #   };
              # }
              # {
              #   name = "ungrammar";
              #   scope = "source.ungrammar";
              #   injection-regex = "ungrammar";
              #   file-types = [
              #     "ungram" "ungrammar"
              #   ];
              #   comment-token = "//";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "unison";
              #   scope = "source.unison";
              #   injection-regex = "unison";
              #   file-types = [ "u" ];
              #   shebangs = [];
              #   auto-format = false;
              #   comment-token = "--";
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   auto-pairs = {
              #   "(" = ")";
              #   "{" = "}";
              #   "[" = "]";
              #   "\"" = "\"";
              #   "`" = "`";
              #   };
              # }
              # {
              #   name = "uxntal";
              #   scope = "source.tal";
              #   injection-regex = "tal";
              #   file-types = [ "tal" ];
              #   auto-format = false;
              #   block-comment-tokens = {
              #     start = "(";
              #     end = ")";
              #   };
              # }
              # {
              #   name = "vala";
              #   scope = "source.vala";
              #   injection-regex = "vala";
              #   file-types = [
              #     "vala"
              #     "vapi"
              #   ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "vala-language-server" ];
              # }
              # {
              #   name = "vento";
              #   scope = "text.html.vto";
              #   file-types = [ "vto" ];
              #   block-comment-tokens = {
              #     start = "{{#";
              #     end = "#}}";
              #   };
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "verilog";
              #   scope = "source.verilog";
              #   file-types = [ "v" "vh" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "svlangserver" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   injection-regex = "verilog";
              # }
              # {
              #   name = "vhdl";
              #   scope = "source.vhdl";
              #   file-types = [
              #     "vhd"
              #     "vhdl"
              #   ];
              #   comment-token = "--";
              #   language-servers = [ "vhdl_ls" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   injection-regex = "vhdl";
              # }
              # {
              #   name = "vhs";
              #   scope = "source.vhs";
              #   file-types = [ "tape" ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "vhs";
              # }
              # {
              #   name = "vim";
              #   scope = "source.vim";
              #   injection-regex = "vim";
              #   comment-token = "\"";
              #   indent = {
              #     tab-width = 4;
              #     unit = "\t";
              #   };
              #   file-types = [
              #     "vim"
              #     { glob = ".vimrc"; }
              #     { glob = ".nvimrc"; }
              #     { glob = ".exrc"; }
              #   ];
              # }
              # {
              #   name = "vue";
              #   scope = "source.vue";
              #   injection-regex = "vue";
              #   file-types = [ "vue" ];
              #   roots = [ "package.json" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   language-servers = [ "vuels" ];
              # }
              # {
              #   name = "wat";
              #   scope = "source.wat";
              #   comment-token = ";;";
              #   block-comment-tokens = {
              #     start = "(;";
              #     end = ";)";
              #   };
              #   file-types = [ "wat" ];
              #   language-servers = [ "wasm-language-tools" ];
              # }
              # {
              #   name = "wast";
              #   scope = "source.wast";
              #   comment-token = ";;";
              #   block-comment-tokens = {
              #     start = "(;";
              #     end = ";)";
              #   };
              #   file-types = [ "wast" ];
              # }
              # {
              #   name = "webc";
              #   scope = "text.html.webc";
              #   injection-regex = "webc";
              #   file-types = [ "webc" ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   grammar = "html";
              # }
              # {
              #   name = "werk";
              #   scope = "source.werk";
              #   file-types = [
              #     "werk"
              #     { glob = "Werkfile"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "wit";
              #   scope = "source.wit";
              #   injection-regex = "wit";
              #   file-types = [ "wit" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #   "(" = ")";
              #   "{" = "}";
              #   "[" = "]";
              #   "\"" = "\"";
              #   "'" = "'";
              #   "<" = ">";
              #   };
              # }
              # {
              #   name = "wgsl";
              #   scope = "source.wgsl";
              #   file-types = [ "wgsl" ];
              #   comment-token = "//";
              #   block-comment-tokens = {
              #     start = "/*";
              #     end = "*/";
              #   };
              #   language-servers = [ "wgsl-analyzer" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "wren";
              #   scope = "source.wren";
              #   injection-regex = "wren";
              #   file-types = [ "wren" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "xit";
              #   scope = "source.xit";
              #   injection-regex = "xit";
              #   file-types = [ "xit" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              # }
              # {
              #   name = "xtc";
              #   scope = "source.xtc";
              #   file-types = [ "xtc" "xpc" "xoa" ];
              #   comment-token = ";";
              # }
              # {
              #   name = "xml";
              #   scope = "source.xml";
              #   injection-regex = "xml";
              #   file-types = [
              #     "ascx"
              #     "atom"
              #     "axaml"
              #     "axml"
              #     "bpmn"
              #     "cpt"
              #     "csl"
              #     "csproj.user"
              #     "dita"
              #     "ditamap"
              #     "dtml"
              #     "fods"
              #     "fodt"
              #     "fxml"
              #     "gir"
              #     "glif"
              #     "gml"
              #     "gpx"
              #     "iml"
              #     "isml"
              #     "jmx"
              #     "launch"
              #     "menu"
              #     "mobileconfig"
              #     "mpd"
              #     "musicxml"
              #     "mxml"
              #     "nuspec"
              #     "opml"
              #     "osc"
              #     "osm"
              #     "plist"
              #     "policy"
              #     "pt"
              #     "publishsettings"
              #     "pubxml"
              #     "pubxml.user"
              #     "rbxlx"
              #     "rbxmx"
              #     "rng"
              #     "rss"
              #     "shproj"
              #     "smil"
              #     "storyboard"
              #     "sublime-snippet"
              #     "svg"
              #     "tld"
              #     "tmx"
              #     "ui"
              #     "vbproj.user"
              #     "vcxproj"
              #     "vcxproj.filters"
              #     "wsdl"
              #     "wxi"
              #     "wxs"
              #     "xaml"
              #     "xbl"
              #     "xib"
              #     "xlf"
              #     "xliff"
              #     "xml"
              #     "xoml"
              #     "xpdl"
              #     "xsd"
              #     "xsl"
              #     "xul"
              #     { glob = "*.tm[Tt]heme"; }
              #   ];
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   auto-pairs = {
              #     "(" = ")";
              #     "{" = "}";
              #     "[" = "]";
              #     "\"" = "\"";
              #     "'" = "'";
              #     "<" = ">";
              #   };
              # }
              {
                name = "yaml";
                scope = "source.yaml";
                file-types = [
                  "sublime-syntax"
                  "yaml"
                  "yml"
                  { glob = ".clang-format"; }
                  { glob = ".clang-tidy"; }
                  { glob = ".clangd"; }
                  { glob = ".gem/credentials"; }
                  { glob = ".kube/config"; }
                  { glob = ".kube/kuberc"; }
                  { glob = ".prettierrc"; }
                ];
                comment-token = "#";
                indent = {
                  tab-width = 2;
                  unit = "  ";
                };
                language-servers = [
                  "yaml-language-server"
                  "ansible-language-server"
                ];
                injection-regex = "yml|yaml";
                formatter = {
                  command = "${yamlfmt}/bin/yamlfmt";
                  args = [ "-" ];
                };
                auto-format = true;
              }
              # {
              #   name = "yuck";
              #   scope = "source.yuck";
              #   injection-regex = "yuck";
              #   file-types = [ "yuck" ];
              #   comment-token = ";";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "zig";
              #   scope = "source.zig";
              #   injection-regex = "zig";
              #   file-types = [ "zig" "zon" ];
              #   roots = [ "build.zig" ];
              #   auto-format = true;
              #   comment-tokens = [
              #     "//" "///" "//!"
              #   ];
              #   language-servers = [ "zls" ];
              #   indent = {
              #     tab-width = 4;
              #     unit = "    ";
              #   };
              #   formatter = {
              #     command = "${zig}/bin/zig";
              #     args = [ "fmt" "--stdin" ];
              #   };
              #   debugger = {
              #     name = "lldb-dap";
              #     transport = "stdio";
              #     command = "${lldb}/bin/lldb-dap";
              #     templates = [
              #       {
              #         name = "binary";
              #         request = "launch";
              #         completion = [
              #           {
              #             name = "binary";
              #             completion = "filename";
              #           }
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           program = "{0}";
              #         };
              #       }
              #       {
              #         name = "attach";
              #         request = "attach";
              #         completion = [ "pid" ];
              #         args = {
              #           console = "internalConsole";
              #           pid = "{0}";
              #         };
              #       }
              #       {
              #         name = "gdbserver attach";
              #         request = "attach";
              #         completion = [
              #           {
              #             name = "lldb connect url";
              #             default = "connect://localhost:3333";
              #           }
              #           {
              #             name = "file";
              #             completion = "filename";
              #           }
              #           "pid"
              #         ];
              #         args = {
              #           console = "internalConsole";
              #           attachCommands = [
              #             "platform select remote-gdb-server"
              #             "platform connect {0}" "file {1}" "attach {2}"
              #           ];
              #         };
              #       }
              #     ];
              #   };
              # }
              # {
              #   name = "werk";
              #   scope = "source.werk";
              #   file-types = [
              #     "werk"
              #     { glob = "Werkfile"; }
              #   ];
              #   comment-token = "#";
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              # }
              # {
              #   name = "wikitext";
              #   scope = "source.wikitext";
              #   file-types = [
              #     "wikimedia" "mediawiki" "wikitext"
              #   ];
              #   language-servers = [ "wikitext-lsp" ];
              #   indent = {
              #     tab-width = 2;
              #     unit = "  ";
              #   };
              #   block-comment-tokens = {
              #     start = "<!--";
              #     end = "-->";
              #   };
              #   word-completion.trigger-length = 4;
              # }
            ];
            language-server = {
              # ameba-ls = {
              #   command = "${ameba-ls}/bin/ameba-ls";
              # };
              # angular = {
              #   command = "${angular-language-server}/bin/ngserver";
              #   args = [
              #     "--stdio"
              #     "--tsProbeLocations" "." "--ngProbeLocations" "."
              #   ];
              # };
              # ansible-language-server = { # unmaintained
              #   command = "${ansible-language-server}/bin/ansible-language-server";
              #   args = [ "--stdio" ];
              # };
              # asm-lsp = {
              #   command = "${asm-lsp}/bin/asm-lsp";
              # };
              # astro-ls = {
              #   command = "${astro-language-server}/bin/astro-ls";
              #   args = [ "--stdio" ];
              #   config = {
              #     typescript = {
              #       tsdk = "node_modules/typescript/lib";
              #     };
              #   };
              # };
              # awk-language-server = {
              #   command = "${awk-language-server}/bin/awk-language-server";
              # };
              bash-language-server = with nodePackages; {
                command = "${bash-language-server}/bin/bash-language-server";
                args = [ "start" ];
              };
              # beancount-language-server = {
              #   command = "${beancount-language-server}/bin/beancount-language-server";
              # };
              # bicep-langserver = {
              #   command = "${bicep}/bin/bicep";
              # };
              # bitbake-language-server = {
              #   command = "${bitbake-language-server}/bin/bitbake-language-server";
              # };
              # blueprint-compiler = {
              #   command = "${blueprint-compiler}/bin/blueprint-compiler";
              #   args = [ "lsp" ];
              # };
              # buf = {
              #   command = "${buf}/bin/buf";
              #   args = [
              #     "beta" "lsp" "--timeout" "0"
              #   ];
              # };
              # cairo-language-server = {
              #   command = "${cairo-lang}/bin/cairo-language-server";
              #   args = [];
              # };
              # clangd = {
              #   command = "${clang-tools}/bin/clangd";
              # };
              # clojure-lsp = {
              #   command = "${clojure-lsp}/bin/clojure-lsp";
              # };
              # cmake-language-server = {
              #   command = "${cmake-language-server}/bin/cmake-language-server";
              # };
              # crystalline = {
              #   command = "${crystalline}/bin/crystalline";
              #   args = [ "--stdio" ];
              # };
              # cuelsp = {
              #   command = "${cuelsp}/bin/cuelsp";
              # };
              # csharp-ls = {
              #   command = "${csharp-ls}/bin/csharp-ls";
              # };
              # dart = {
              #   command = "${dart}/bin/dart";
              #   args = [ "language-server" "--client-id=helix" ];
              # };
              # dhall-lsp-server = {
              #   command = "${dhall-lsp-server}/bin/dhall-lsp-server";
              # };
              # docker-langserver = {
              #   command = "${dockerfile-language-server}/bin/dockerfile-language-server";
              #   args = [ "--stdio" ];
              # };
              # docker-compose-langserver = {
              #   command = "${docker-compose-language-service}/bin/docker-compose-langserver";
              #   args = [ "--stdio" ];
              # };
              # docker-language-server = {
              #   command = "${docker-language-server}/bin/docker-language-server";
              #   args = [ "start" "--stdio" ];
              # };
              # dot-language-server = {
              #   command = "${dot-language-server}/bin/dot-language-server";
              #   args = [ "--stdio" ];
              # };
              # dts-lsp = {
              #   command = "${dts-lsp}/bin/dts-lsp";
              # };
              # earthlyls = {
              #   command = "${earthlyls}/bin/earthlyls";
              # };
              # elixir-ls = {
              #   command = "${elixir-ls}/bin/elixir-ls";
              #   config = {
              #     elixirLS.dialyzerEnabled = false;
              #   };
              # };
              # elm-language-server = with elmPackages; {
              #   command = "${elm-language-server}/bin/elm-language-server";
              # };
              # elvish = {
              #   command = "${elvish}/bin/elvish";
              #   args = [ "-lsp" ];
              # };
              # ember-language-server = {
              #   command = "${ember-language-server}/bin/ember-language-server";
              #   args = [ "--stdio" ];
              # };
              # elp = {
              #   command = "${erlang-language-platform}/bin/elp";
              #   args = [ "server" ];
              # };
              # fish-lsp = {
              #   command = "${fish-lsp}/bin/fish-lsp";
              #   args = [ "start" ];
              #   environment = {
              #     fish_lsp_show_client_popups = "false";
              #   };
              # };
              # fennel-ls = {
              #   command = "${fennel-ls}/bin/fennel-ls";
              # };
              # fortls = {
              #   command = "${fortls}/bin/fortls";
              #   args = [ "--lowercase_intrinsics" ];
              # };
              # fsharp-ls = {
              #   command = "${fsautocomplete}/bin/fsautocomplete";
              #   config = {
              #     AutomaticWorkspaceInit = true;
              #   };
              #   };
              # gleam = {
              #   command = "${gleam}/bin/gleam";
              #   args = [ "lsp" ];
              # };
              # glsl_analyzer = {
              #   command = "${glsl_analyzer}/bin/glsl_analyzer";
              # };
              # gopls = {
              #   command = "${gopls}/bin/gopls";
              #   config.hints = {
              #     assignVariableTypes = true;
              #     compositeLiteralFields = true;
              #     compositeLiteralTypes = true;
              #     constantValues = true;
              #     functionTypeParameters = true;
              #     parameterNames = true;
              #     rangeVariableTypes = true;
              #   };
              # };
              # golangci-lint-lsp = {
              #   command = "${golangci-lint-langserver}/bin/golangci-lint-langserver";
              #   config = {
              #     command = [
              #       "${golangci-lint}/bin/golangci-lint"
              #       "run"
              #       "--output.json.path=stdout"
              #       "--show-stats=false"
              #       "--issues-exit-code=1"
              #     ];
              #   };
              # };
              # graphql-language-server = with nodePackages; {
              #   command = "${graphql-language-service-cli}/bin/graphql-lsp";
              #   args = [
              #     "server" "-m" "stream"
              #   ];
              # };
              harper-ls = {
                command = "${harper}/bin/harper-ls";
                args = [ "--stdio" ];
              };
              haskell-language-server = {
                command = "${haskell-language-server}/bin/haskell-language-server-wrapper";
                args = [
                  "--lsp"
                ];
              };
              # helm_ls = {
              #   command = "${helm-ls}/bin/helm_ls";
              #   args = [ "serve" ];
              # };
              # hyprls = {
              #   command = "${hyprls}/bin/hyprls";
              # };
              # idris2-lsp = with idris2Packages; {
              #   command = "${idris2Lsp}/bin/idris2-lsp";
              # };
              jedi = {
                command = "${python_list.python_pkgs}/bin/jedi-language-server";
              };
              # jdtls = {
              #   command = "${jdt-language-server}/bin/jdtls";
              # };
              # jsonnet-language-server = {
              #   command = "${jsonnet-language-server}/bin/jsonnet-language-server";
              #   args= [
              #     "-t" "--lint"
              #   ];
              # };
              julia = {
                command = "${julia_list.julia_pkgs}/bin/julia";
                timeout = 60;
                args = [
                  "--startup-file=no" "--history-file=no"
                  "--quiet" "-e" "using LanguageServer; runserver()"
                ];
              };
              # just-lsp = {
              #   command = "just-lsp";
              # };
              # jq-lsp = {
              #   command = "${jq-lsp}/bin/jq-lsp";
              # };
              # koka = {
              #   command = "${koka}/bin/koka";
              #   args = [
              #     "--language-server"
              #     "--lsstdio"
              #   ];
              # };
              # kotlin-language-server = {
              #   command = "${kotlin-language-server}/bin/kotlin-language-server";
              # };
              # koto-ls = {
              #   command = "${koto-ls}/bin/koto-ls";
              # };
              # lean = {
              #   command = "${lean}/bin/lean";
              #   args = [ "--server" ];
              # };
              # lua-language-server = {
              #   command = "${lua-language-server}/bin/lua-language-server";
              #   config = {
              #     Lua = {
              #       hint = {
              #         enable = true;
              #         arrayIndex = "Enable";
              #         setType = true;
              #         paramName = "All";
              #         paramType = true;
              #         await = true;
              #       };
              #     };
              #   };
              # };
              # luau = {
              #   command = "${luau-lsp}/bin/luau-lsp";
              #   args = [ "lsp" ];
              # };
              ltex-ls = {
                command = "${ltex-ls}/bin/ltex-ls";
              };
              ltex-ls-plus = {
                command = "${ltex-ls-plus}/bin/ltex-ls-plus";
              };
              markdown-oxide = {
                command = "${markdown-oxide}/bin/markdown-oxide";
              };
              marksman = {
                command = "${marksman}/bin/marksman";
                args = [ "server" ];
              };
              # mesonlsp = {
              #   command = "${mesonlsp}/bin/mesonlsp";
              #   args = [ "--lsp" ];
              # };
              metals = {
                command = "${metals}/bin/metals";
                config = {
                  "isHttpEnabled" = true;
                  metals = {
                    inlayHints = {
                      typeParameters = {
                        enable = true;
                      };
                      hintsInPatternMatch = {
                        enable = true;
                      };
                    };
                  };
                };
              };
              # mint = {
              #   command = "${mint}/bin/mint";
              #   args = [ "ls" ];
              # };
              # neocmakelsp = {
              #   command = "${neocmakelsp}/bin/neocmakelsp";
              #   args = [ "stdio" ];
              # };
              nil = {
                command = "${nil}/bin/nil";
              };
              # nimlangserver = {
              #   command = "${nimlangserver}/bin/nimlangserver";
              # };
              # nimlsp = {
              #   command = "${nimlsp}/bin/nimlsp";
              # };
              nixd = {
                command = "${nixd}/bin/nixd";
              };
              # nls = {
              #   command = "${nls}/bin/nls";
              # };
              # nu-lsp = {
              #   command = "${nushell}/bin/nu";
              #   args = [ "--lsp" ];
              # };
              # ocamllsp = with ocamlPackages; {
              #   command = "${ocaml-lsp}/bin/ocamllsp";
              # };
              # ols = {
              #   command = "${ols}/bin/ols";
              #   args = [];
              # };
              # omnisharp = {
              #   command = "${omnisharp-roslyn}/bin/OmniSharp";
              #   args = [ "--languageserver" ];
              # };
              # openscad-lsp = {
              #   command = "${openscad-lsp}/bin/openscad-lsp";
              #   args = [ "--stdio" ];
              # };
              # pbkit = {
              #   command = "${pb}/bin/pb";
              #   args = [ "lsp" ];
              # };
              # perlnavigator = {
              #   command = "${perlnavigator}/bin/perlnavigator";
              #   args= [ "--stdio" ];
              # };
              # pest-language-server = {
              #   command = "${pest-ide-tools}/bin/pest-language-server";
              # };
              # phpactor = {
              #   command = "${phpactor}/bin/phpactor";
              #   args= [ "language-server" ];
              # };
              # prisma-language-server = {
              #   command = "${"@prisma/language-server"}/bin/prisma-language-server";
              #   args = [ "--stdio" ];
              # };
              # protols = {
              #   command = "${protols}/bin/protols";
              #   args = [];
              # };
              # purescript-language-server = with nodePackages; {
              #   command = "${purescript-language-server}/bin/purescript-language-server";
              #   args = [ "--stdio" ];
              # };
              pylsp = {
                command = "${python_list.python_pkgs}/bin/pylsp";
                config = {
                  pylsp = {
                    plugins = {
                      ruff.enabled = true;
                      black.enabled = true;
                    };
                  };
                };
              };
              # # pyrefly = {
              # #   command = "${pyrefly}/bin/pyrefly";
              # #   args = [ "lsp" ];
              # # };
              pylyzer = {
                command = "${pylyzer}/bin/pylyzer";
                args = [ "--server" ];
              };
              pyright = {
                command = "${pyright}/bin/pyright-langserver";
                args = [ "--stdio" ];
                config = {
                  python = {
                    analysis = {
                      typeCheckingMode = "basic";
                    };
                  };
                };
              };
              # basedpyright = {
              #   command = "${basedpyright}/bin/basedpyright-langserver";
              #   args = [ "--stdio" ];
              #   config = {};
              # };
              # qmlls = with kdePackages; {
              #   command = "${qtdeclarative}/bin/qmlls";
              # };
              r = {
                command = "${r_list.r_pkgs}/bin/R";
                args = [ "--no-echo" "-e" "languageserver::run()" ];
              };
              # racket = {
              #   command = "${racket}/bin/racket";
              #   args = [ "-l" "racket-langserver" ];
              # };
              # regols = {
              #   command = "${regols}/bin/regols";
              # };
              # rescript-language-server = {
              #   command = "${rescript-language-server}/bin/rescript-language-server";
              #   args = [ "--stdio" ];
              # };
              # ruby-lsp = {
              #   command = "${ruby-lsp}/bin/ruby-lsp";
              # };
              ruff = {
                command = "${ruff}/bin/ruff";
                config = {
                  settings = {
                    args = [ "server" ];
                  };
                };
              };
              rust-analyzer = {
                command = "${rust-analyzer}/bin/rust-analyzer";
                config = {
                  inlayHints = {
                    bindingModeHints.enable = false;
                    closingBraceHints.minLines = 10;
                    closureReturnTypeHints.enable = "with_block";
                    discriminantHints.enable = "fieldless";
                    lifetimeElisionHints.enable = "skip_trivial";
                    typeHints.hideClosureInitialization = false;
                  };
                  files = {
                    watcher = "server";
                  };
                };
              };
              # serve-d = {
              #   command = "${serve-d}/bin/serve-d";
              # };
              # slint-lsp = {
              #   command = "${slint-lsp}/bin/slint-lsp";
              #   args = [];
              # };
              # solargraph = with rubyPackages; {
              #   command = "${solargraph}/bin/solargraph";
              #   args = [ "stdio" ];
              # };
              # solc = {
              #   command = "${solc}/bin/solc";
              #   args = [ "--lsp" ];
              # };
              # sourcepawn-studio = {
              #   command = "${sourcepawn-studio}/bin/sourcepawn-studio";
              # };
              # spade-language-server = {
              #   command = "${spade}/bin/spade-language-server";
              # };
              sqls = {
                command = "${sqls}/bin/sqls";
              };
              # starpls = {
              #   command = "${starpls}/bin/starpls";
              # };
              # superhtml = {
              #   command = "${superhtml}/bin/superhtml";
              #   args = [ "lsp" ];
              # };
              # svelteserver = {
              #   command = "${svelte-language-server}/bin/svelteserver";
              #   args = [ "--stdio" ];
              #   config = {
              #     configuration = {
              #       typescript = {
              #         inlayHints.parameterTypes.enabled = true;
              #         inlayHints.variableTypes.enabled = true;
              #         inlayHints.propertyDeclarationTypes.enabled = true;
              #         inlayHints.functionLikeReturnTypes.enabled = true;
              #         inlayHints.enumMemberValues.enabled = true;
              #         inlayHints.parameterNames.enabled = "all";
              #       };
              #       javascript = {
              #         inlayHints.parameterTypes.enabled = true;
              #         inlayHints.variableTypes.enabled = true;
              #         inlayHints.propertyDeclarationTypes.enabled = true;
              #         inlayHints.functionLikeReturnTypes.enabled = true;
              #         inlayHints.enumMemberValues.enabled = true;
              #         inlayHints.parameterNames.enabled = "all";
              #       };
              #     };
              #   };
              # };
              # # svlangserver = {
              # #   command = "${svlangserver}/bin/svlangserver";
              # #   args = [];
              # # };
              # swipl = {
              #   command = "${swi-prolog}/bin/swipl";
              #   args = [
              #     "-g" "use_module(library(lsp_server))"
              #     "-g" "lsp_server:main" "-t" "halt"
              #     "--" "stdio"
              #   ];
              # };
              # tailwindcss-ls = {
              #   command = "${tailwindcss-language-server}/bin/tailwindcss-language-server";
              #   args = [ "--stdio" ];
              # };
              taplo = {
                command = "${taplo}/bin/taplo";
                args = [ "lsp" "stdio" ];
              };
              # teal-language-server = with luajitPackages; {
              #   command = "${teal-language-server}/bin/teal-language-server";
              # };
              templ = {
                command = "${templ}/bin/templ";
                args = [ "lsp" ];
              };
              # terraform-ls = {
              #   command = "${terraform-ls}/bin/terraform-ls";
              #   args = [ "serve" ];
              # };
              texlab = {
                command = "${texlab}/bin/texlab";
              };
              tombi = {
                command = "${tombi}/bin/tombi";
                args = [ "lsp" ];
              };
              # tinymist = {
              #   command = "${tinymist}/bin/tinymist";
              # };
              # ts_query_ls = {
              #   command = "${ts_query_ls}/bin/ts_query_ls";
              # };
              ty = {
                command = "${ty}/bin/ty";
                args = [ "server" ];
              };
              # typespec = {
              #   command = "${typespec}/bin/tsp-server";
              #   args = [ "--stdio" ];
              # };
              # typescript-language-server = with nodePackages; {
              #   command = "${typescript-language-server}/bin/typescript-language-server";
              #   args = [ "--stdio" ];
              #   config = {
              #     hostInfo = "helix";
              #     typescript.inlayHints = {
              #       includeInlayEnumMemberValueHints = true;
              #       includeInlayFunctionLikeReturnTypeHints = true;
              #       includeInlayFunctionParameterTypeHints = true;
              #       includeInlayParameterNameHints = "all";
              #       includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              #       includeInlayPropertyDeclarationTypeHints = true;
              #       includeInlayVariableTypeHints = true;
              #     };
              #     javascript.inlayHints = {
              #       includeInlayEnumMemberValueHints = true;
              #       includeInlayFunctionLikeReturnTypeHints = true;
              #       includeInlayFunctionParameterTypeHints = true;
              #       includeInlayParameterNameHints = "all";
              #       includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              #       includeInlayPropertyDeclarationTypeHints = true;
              #       includeInlayVariableTypeHints = true;
              #     };
              #   };
              # };
              typos-lsp = {
                command = "${typos-lsp}/bin/typos-lsp";
              };
              # vala-language-server = {
              #   command = "${vala-language-server}/bin/vala-language-server";
              # };
              vale-ls = {
                command = "${vale-ls}/bin/vale-ls";
              };
              # verible-verilog-ls = {
              #   command = "${verible}/bin/verible-verilog-ls";
              #   args = [
              #     "--rules_config_search"
              #     "--indentation_spaces=4"
              #   ];
              # };
              # vhdl_ls = {
              #   command = "${vhdl-ls}/bin/vhdl_ls";
              #   args = [];
              # };
              # vscode-css-language-server = with nodePackages; {
              #   command = "${vscode-langservers-extracted}/bin/vscode-css-language-server";
              #   args = [ "--stdio" ];
              #   config = {
              #     provideFormatter = true;
              #     css = {
              #       validate = {
              #         enable = true;
              #       };
              #     };
              #   };
              # };
              # vscode-eslint-language-server = with nodePackages; {
              #   command = "${vscode-langservers-extracted}/bin/vscode-eslint-language-server";
              #   args = [ "--stdio" ];
              #   config = {
              #     validate = "on";
              #     experimental = {
              #       useFlatConfig = false;
              #     };
              #     rulesCustomizations = [];
              #     run = "onType";
              #     problems = {
              #       shortenToSingleLine = false;
              #     };
              #     nodePath = "";
              #     codeAction = {
              #       disableRuleComment = {
              #         enable = true;
              #         location = "separateLine";
              #       };
              #       showDocumentation = {
              #         enable = true;
              #       };
              #     };
              #     workingDirectory = {
              #       mode = "location";
              #     };
              #   };
              # };
              # vscode-html-language-server = with nodePackages; {
              #   command = "${vscode-langservers-extracted}/bin/vscode-html-language-server";
              #   args = [ "--stdio" ];
              #   config = {
              #     provideFormatter = true;
              #   };
              # };
              vscode-json-language-server = with nodePackages; {
                command = "${vscode-langservers-extracted}/bin/vscode-json-language-server";
                args = [ "--stdio" ];
                config = {
                  provideFormatter = true;
                  json = {
                    validate = {
                      enable = true;
                    };
                  };
                };
              };
              # vuels = {
              #   command = "${vue-language-server}/bin/vue-language-server";
              #   args = [ "--stdio" ];
              #   config = {
              #     typescript = {
              #       tsdk = "node_modules/typescript/lib/";
              #     };
              #   };
              # };
              # wasm-language-tools = {
              #   command = "${wasm-language-tools}/bin/wat_server";
              # };
              # wgsl-analyzer = {
              #   command = "${wgsl-analyzer}/bin/wgsl-analyzer";
              # };
              yaml-language-server = {
                command = "${yaml-language-server}/bin/yaml-language-server";
                args = [ "--stdio" ];
              };
              # zls = {
              #   command = "${zls}/bin/zls";
              # };
              # mojo-lsp-server = {
              #   command = "${pixi}/bin/pixi";
              #   args = [ "run" "mojo-lsp-server" ];
              # };
            };
          };
        };
      };
    };
  };
}
