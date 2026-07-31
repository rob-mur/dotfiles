{pkgs, ...}:
with pkgs; {
  home.packages = [pkgs-unstable.opencode];
}
