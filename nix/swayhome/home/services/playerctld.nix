{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        playerctld = {
          enable = true;
          package = playerctl;
        };
      };
    };
  };
}
