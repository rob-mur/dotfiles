{pkgs, ...}:
with pkgs; {
  home.packages = [
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
  ];
}
