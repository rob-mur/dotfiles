{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
    };
  };
}
