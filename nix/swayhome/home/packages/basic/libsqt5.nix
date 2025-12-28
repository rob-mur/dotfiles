{
  pkgs,
  enable_libsqt5_pkgs ? false,
  ...
}:
with pkgs;
let

  libsqt5_pkgs =
    if enable_libsqt5_pkgs then with libsForQt5.qt5; [
      qtwayland
    ]
    else
      [];
in {

  inherit libsqt5_pkgs;
}

