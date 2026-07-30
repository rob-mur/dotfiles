{pkgs, ...}: let
in {
  home.packages = with pkgs; [protonmail-desktop];
}
