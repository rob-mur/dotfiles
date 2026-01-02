{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  services = {
    displayManager = {
      sddm.enable = true;
      enable = true;
      defaultSession = "sway";
      sessionPackages = [sway];
      autoLogin = {
        enable = config.autoLogin;
        user = "${config.name}";
      };
    };
  };
}
