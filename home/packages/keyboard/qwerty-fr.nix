{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  # NOTE: The NixOS xserver keyboard layout configuration has been moved to
  # nixos/hardware/keyboard.nix to properly separate system-level from home-manager config

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
}
