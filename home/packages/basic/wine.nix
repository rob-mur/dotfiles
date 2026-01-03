{
  pkgs,
  enable_wine_pkgs ? false,
  ...
}:
with pkgs;
let

  wine_pkgs =
    if enable_wine_pkgs then [
      wineWowPackages.stable
    ]
    else
      [];
in {

  inherit wine_pkgs;
}

