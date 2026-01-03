{config, ...}: let
in {
  programs = {
        bat = {
          enable = false;
          config = {
            italic-text = "always";
            paging = "always";
            tabs = "2";
      };
    };
  };
}
