{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  services = {
    displayManager = {
    sddm.enable = false;
      enable = true;
      ly = {
        enable = true;
        settings = {
          animation = "none";
          blank_box = false;
          default_input = "password";
          save = false;
        };
      };
      defaultSession = "Sway";
      sessionPackages = [ sway ];
      autoLogin = {
        enable = false;
        user = "${profile.name}";
      };
    };
  };
}
