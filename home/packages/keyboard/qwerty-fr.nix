{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      home.packages = [qwerty-fr];
      home.keyboard.options = ["caps:swapescape"];
      wayland.windowManager.sway = {
        # We must disable config checking and defer to runtime as the keyboard layout
        # has not been defined until the build is complete
        checkConfig = false;

        extraConfig = ''
          input * {
            xkb_layout us_qwerty-fr
            xkb_options "caps:swapescape"
          }
        '';
      };
    };
  };
  services.xserver = {
    enable = true;
    xkb = {
      extraLayouts.us_qwerty-fr = {
        description = "Qwerty-fr";
        languages = ["eng" "fra"];
        symbolsFile = "${pkgs.qwerty-fr}/share/X11/xkb/symbols/us_qwerty-fr";
      };
    };
  };
}
