{
  config,
  lib,
  pkgs,
  ...
}: let
  alias = import ./../user/abbr {inherit config;};
in {
  # Import all home modules directly - they now contain unwrapped configs
  imports = [
    ./accounts
    ./config
    ./dconf
    ./fonts
    ./packages
    ./programs
    ./services
    ./shell
    ./themes
    ./wayland
    ./xdg
  ];

  # Stub options for NixOS-specific services that modules might reference
  # These prevent errors but have no effect in standalone mode
  options.services = {
    xserver = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for NixOS xserver service (non-functional in standalone mode)";
    };

    dbus = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Stub for NixOS dbus service (non-functional in standalone mode)";
    };
  };

  # Direct home-manager configuration for standalone mode
  config.home = {
    username = config.name;
    homeDirectory = "/home/${config.name}";
    stateVersion = config.version;
    shellAliases = alias.abbr;
    sessionVariables = {
      # Session
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";

      # Wayland
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";

      # GTK Theme
      GTK_THEME = "Breeze-Dark";
    };
  };
}
