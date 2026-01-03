{
  pkgs,
  enable_archive_pkgs ? false,
  ...
}:
with pkgs;
let

  archive_pkgs =
    if enable_archive_pkgs then [
      atool
      bzip2
      gzip
      libarchive
      lz4
      lzip
      lzo
      lzop
      p7zip
      rzip
      unzip
      xz
      zip
      zstd
    ]
    else
      [];
in {

  inherit archive_pkgs;
}

