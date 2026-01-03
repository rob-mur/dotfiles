{config, ...}: let
in {
  security = {
    polkit.enable = true;
    rtkit = {
      enable = true;
    };
    pam = {
      services = {
        swaylock = {};
        sddm.enableGnomeKeyring = true;
      };
    };
    sudo = {
      enable = true;
    };
  };
}
