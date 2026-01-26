{
  pkgs,
  config,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      enable = true;
      defaultSession = "sway";
      sessionPackages = [pkgs.sway];
      autoLogin = {
        enable = config.autoLogin;
        user = "${config.name}";
      };
    };
  };
}
