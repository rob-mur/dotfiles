{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      # xdotdool to be able to close programs
      home.packages = [xdotool];

      services = {
        kdeconnect = {
          enable = true;
          indicator = false;
        };
      };
    };
  };
}
