{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  services = {
        playerctld = {
          enable = true;
          package = playerctl;
    };
  };
}
