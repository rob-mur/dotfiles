{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  # xdotdool to be able to close programs
      home.packages = [xdotool];

      services = {
        kdeconnect = {
          enable = true;
          indicator = false;
    };
  };
}
