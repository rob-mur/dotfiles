{
  pkgs,
  config,
  inputs,
  ...
}: let
  alias = import ./../user/abbr {inherit config;};
in {
  home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
    useGlobalPkgs = true;

    # Wrap all module imports under users.${config.name}
    # The imported modules now contain unwrapped home-manager configs
    users.${config.name} = {
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

      home = {
        homeDirectory = "/home/${config.name}";
        stateVersion = "${config.version}";
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
    };
  };
}
