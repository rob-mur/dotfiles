{pkgs, ...}:
with pkgs; {
  home.packages = [pkgs-unstable.gemini-cli];
}
