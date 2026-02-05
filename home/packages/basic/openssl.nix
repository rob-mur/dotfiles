{pkgs, ...}:
with pkgs; {
  home.packages = [
    openssl
  ];
}
