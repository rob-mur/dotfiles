{lib, ...}: {
  options = {
    machineType = lib.mkOption {
      type = lib.types.enum ["desktop" "laptop_perso" "work-laptop"];
      default = "desktop";
      description = "Machine profile to use";
    };

    hostDir = lib.mkOption {
      type = lib.types.str;
      default = ".";
      description = "The folder the host flake is in - set is used by abbr snrs";
    };

    name = lib.mkOption {
      type = lib.types.str;
      default = "rob";
      description = "Username";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "rmurphyswimmer@gmail.com";
      description = "Email";
    };

    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "robert.murphy@descartesunderwriting.com";
      description = "Email used as the author identity for git and jj commits";
    };

    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "State version for nix";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_GB.UTF-8";
      description = "System locale";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "dev";
      description = "Hostname";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Paris";
      description = "Timezone (used when autoTimezone is false)";
    };

    autoTimezone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Detect the timezone automatically from location (GeoClue) instead of using the static timezone";
    };

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us_qwerty-fr";
      description = "Keyboard layout";
    };

    pass = lib.mkOption {
      type = lib.types.str;
      default = "pass";
      description = "Password store directory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "group to put the user in";
    };

    fullname = lib.mkOption {
      type = lib.types.str;
      default = "Rob Murphy";
      description = "Display name";
    };

    autoLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to login automatically without password";
    };

    nvidiaForDisplay = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether the NVIDIA GPU is used for Wayland scanout. When false, Sway
        runs on the Intel iGPU only and the NVIDIA card is left idle for
        CUDA/Docker workloads. The driver stays loaded either way, so
        nvidia-smi works in both modes.
      '';
    };

    enableSteam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Steam in the user profile.";
    };
  };
}
