{config, ...}: let
in {
  programs = {
        wofi = {
          enable = false;
          settings = {
            location = "bottom-right";
            allow_markup = true;
            width = 400;
            height = 200;
      };
    };
  };
}
