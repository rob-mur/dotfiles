{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home = {
        packages = [
          veusz
        ];
  };
}
