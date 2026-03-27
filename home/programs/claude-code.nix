{pkgs, ...}:
with pkgs; {
  home.packages = [pkgs-unstable.claude-code pkgs-unstable.sox];
}
