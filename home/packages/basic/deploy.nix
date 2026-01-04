{
  pkgs,
  enable_deploy_pkgs ? false,
  ...
}:
with pkgs;
let

  deploy_pkgs =
    if enable_deploy_pkgs then [
      hut
    ]
    else
      [];
in {

  inherit deploy_pkgs;
}

