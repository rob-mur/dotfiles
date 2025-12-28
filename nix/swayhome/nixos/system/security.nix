{ ... }: let

  profile = import ./../../user/profile {};

in {
  security = {
    polkit.enable = true;
    rtkit = {
      enable = true;
    };
    pam = {
      services = {
        swaylock = {};
      };
    };
    sudo = {
      enable = false;
      wheelNeedsPassword = false;
    };
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["${profile.name}"];
          groups = ["wheel"];
          keepEnv = true;
          noPass = true;
        }
      ];
      wheelNeedsPassword = false;
    };
  };
}
