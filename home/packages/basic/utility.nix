{pkgs, ...}:
with pkgs; {
  home.packages = [
    lazyjj
    gnumake
    uv
  ];
}
