{pkgs, ...}:
with pkgs; {
  home.packages = [
    jjui
    gnumake
    uv
  ];
}
