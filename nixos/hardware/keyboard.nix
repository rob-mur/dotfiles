{pkgs, ...}: {
  hardware = {
    keyboard = {
      qmk = {
        enable = true;
      };
    };
  };

  # Keyboard layout configuration for xserver
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
