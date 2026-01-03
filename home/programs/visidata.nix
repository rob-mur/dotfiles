{config, ...}: let
in {
  programs = {
        visidata = {
          enable = true;
          visidatarc = ''
            options.min_memory_mb=100

            def median(values):
                L = sorted(values)
                return L[len(L)//2]
            vd.aggregator('median', median)

            options.color_active_status = "bold"
            options.color_aggregator = "bold white"
            options.color_bottom_hdr = "underline white"
            options.color_column_sep = "blue"
            options.color_current_col = "bold"
            options.color_current_hdr = "bold white on blue"
            options.color_current_row = "bold white on blue"
            options.color_default = "white"
            options.color_default_hdr = "bold"
            options.color_menu = "bold blue"
            options.color_menu_active = "bold white on blue"
            options.color_menu_help = "blue"
          '';
    };
  };
}
