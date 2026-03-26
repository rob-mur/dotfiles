{pkgs, ...}:
with pkgs; {
  home.packages = [obsidian syncthing];
}
