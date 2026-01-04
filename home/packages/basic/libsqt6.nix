{
  pkgs,
  enable_libsqt6_pkgs ? false,
  ...
}:
with pkgs;
let

  libsqt6_pkgs =
    if enable_libsqt6_pkgs then with kdePackages; [
      qtwayland
    ]
    else
      [];
in {

  inherit libsqt6_pkgs;
}

