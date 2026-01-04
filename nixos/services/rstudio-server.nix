{
  pkgs,
  ...
}:
with pkgs;
let

  r_list = import ./../../library/r_pkgs.nix {
    inherit pkgs;
  };

in {
  services = {
    rstudio-server  = {
      enable = false;
      listenAddr = "127.0.0.1";
      package = let
        rstudioserverpkgs =
        (
          rstudioServerWrapper.override {
            packages = r_list.r_pkgs;
          }
        );
      in
        rstudioserverpkgs;
    };
  };
}
