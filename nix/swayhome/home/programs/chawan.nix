{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        chawan = {
          enable = true;
          settings = {
            start = {
              visual-home = "https://lite.duckduckgo.com";
            };
            buffer = {
              autofocus = true;
              cookie = true;
              images = false;
              styling = false;
            };
            display = {
              color-mode = "eight-bit";
              image-mode = "kitty";
            };
            external = {
              copy-cmd = "wl-copy";
              paste-cmd = "wl-paste";
            };
            page = {
              "C-k" = "() => pager.load('ddg:')";
            };
          };
        };
      };
    };
  };
}
