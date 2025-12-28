{
  pkgs,
  perl_withpackages ? false,
  ...
}:
with pkgs;
let

  perl_pkgs =
    if perl_withpackages then
    (
      perl.withPackages ( ps:
        with ps; [
          IOSocketSSL
          JSONXS
        ]
      )
    )
    else
      perl;

in {

  inherit perl_pkgs;

}
