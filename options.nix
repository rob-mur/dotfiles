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
      description = "Timezone";
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
  };
}
