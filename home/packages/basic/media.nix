{pkgs, ...}:
with pkgs; {
  home.packages = [
    ffmpeg
    mediainfo
  ];
}
