{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home = {
        packages = with kdePackages; [
          kdenlive
        ];
  };
}
