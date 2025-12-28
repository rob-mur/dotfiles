{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        btop = {
          enable = true;
          settings = {
            color_theme = "horizon";
            theme_background = false;
            truecolor = false;
            force_tty = false;
            vim_keys = true;
            rounded_corners = false;
            graph_symbol = "braille";
            update_ms = 2000;
          };
        };
      };
    };
  };
}
