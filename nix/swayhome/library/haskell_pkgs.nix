{
  pkgs,
  haskell_withpackages ? false,
  ...
}:
with pkgs;
let

  haskell_list_pkgs = (p: with p;
    [
      aeson
      async
      conduit
      containers
      esqueleto
      ghc
      ghcid
      hlint
      hpack
      lens
      pandoc
      parsec
      stack
      stm
      text
      vector
    ]
  );

  haskell_pkgs =
    if haskell_withpackages then
      ( haskellPackages.ghcWithPackages 
        haskell_list_pkgs
      )
    else
      ghc;

in {

  inherit haskell_pkgs;

}
