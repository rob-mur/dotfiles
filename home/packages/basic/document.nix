{
  pkgs,
  enable_document_pkgs ? false,
  ...
}:
with pkgs;
let

  document_pkgs =
    if enable_document_pkgs then [
      bc
      catdoc
      ghostscript
      odt2txt
      poppler-utils
      xlsx2csv
    ]
    else
      [];
in {

  inherit document_pkgs;
}

