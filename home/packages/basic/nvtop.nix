{
  pkgs,
  enable_nvtop_pkgs ? false,
  ...
}:
with pkgs;
let

  nvtop_pkgs =
    if enable_nvtop_pkgs then with nvtopPackages;[
      amd
    ]
    else
      [];
in {

  inherit nvtop_pkgs;
}

