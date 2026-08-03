{pkgs, ...}:
with pkgs; {
  # Only the formats actually reached for by hand. gzip/bzip2/xz/zstd are
  # already in the system closure via other dependencies, so they are not
  # listed here.
  home.packages = [
    libarchive
    p7zip
    unzip
    zip
  ];
}
