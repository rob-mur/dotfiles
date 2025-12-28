{
  pkgs,
  enable_downloader_pkgs ? false,
  ...
}:
with pkgs;
let

  downloader_pkgs =
    if enable_downloader_pkgs then [
      axel
      libgen-cli
      tdl
      wget
      youtube-tui
      ytmdl    ]
    else
      [];
in {

  inherit downloader_pkgs;
}

