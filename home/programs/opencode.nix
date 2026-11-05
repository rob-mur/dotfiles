{pkgs, ...}:
with pkgs; {
  home.packages = [pkgs.opencode];
}
