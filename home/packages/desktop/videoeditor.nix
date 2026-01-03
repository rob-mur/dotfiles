{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      home = {
        packages = with kdePackages; [
          kdenlive
        ];
      };
    };
  };
}
