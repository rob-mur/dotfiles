{
  pkgs,
  ...
}:
let

  profile = import ./../user/profile {};
  alias = import ./../user/abbr {};

  python_list = import ./../library/python_pkgs.nix {
    inherit pkgs;
  };
  r_list = import ./../library/r_pkgs.nix {
    inherit pkgs;
  };

in {
  imports = [
    <home-manager/nixos>
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

  home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
    useGlobalPkgs = true;
    users.${profile.name} = {
      home = {
        homeDirectory = "/home/${profile.name}";
        stateVersion = "${profile.version}";
        shellAliases = alias.abbr;
        sessionVariables = {
          # Session
          XDG_CURRENT_DESKTOP = "sway";
          XDG_SESSION_DESKTOP = "sway";
          XDG_SESSION_TYPE = "wayland";

          # Wayland
          MOZ_ENABLE_WAYLAND = "1";
          MOZ_USE_XINPUT2 = "1";
          QT_QPA_PLATFORM="wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
          SDL_VIDEODRIVER = "wayland";

          # GTK Theme
          GTK_THEME= "Breeze-Dark";

          # Java
          _JAVA_AWT_WM_NONREPARENTING=1;

          # SSH
          SSH_ASKPASS_REQUIRE = "prefer";

          # R library
          R_LIBS_USER = "/home/${profile.name}/.rlibrary";

          # Quarto
          QUARTO_PYTHON = "${python_list.python_pkgs}/bin/python";
          QUARTO_R  = "${r_list.r_pkgs}/bin/R";

          # Reticulate
          RETICULATE_PYTHON = "${python_list.python_pkgs}/bin/python";
        };
      };
    };
  };
}
