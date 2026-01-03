{
  pkgs,
  enable_media_pkgs ? false,
  ...
}:
with pkgs;
let

  media_pkgs =
    if enable_media_pkgs then [
      ffmpeg
      imagemagick
      inxi
      mediainfo
      tagutil
      wiremix
      # exiftool
      # ffmpegthumbnailer
      # glow
      # mpc
      # mpvpaper
      # optipng
      # scour
    ]
    else
      [];
in {

  inherit media_pkgs;
}
