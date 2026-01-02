{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        password-store = {
          enable = true;
          package = pass-wayland.withExtensions (
            exts: [
              exts.pass-checkup
              exts.pass-genphrase
              exts.pass-import
              exts.pass-otp
              exts.pass-tomb
              exts.pass-update
            ]
          );
          settings = {
            PASSWORD_STORE_DIR = "/home/${config.name}/${config.pass}";
          };
        };
      };
    };
  };
}
