{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  services = {
    greetd = {
      enable = false;
      settings = rec {
        initial_session = {
          command = "${sway}/bin/sway";
          user = "${config.name}";
        };
        default_session = initial_session;
      };
    };
  };
}
