{
  pkgs,
  config,
  ...
}: let
in {
  home.packages = with pkgs; [
        jujutsu
        lazyjj
      ];
}
