{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home = {
        packages = [
          libreoffice
          tipp10
          zotero
        ];
  };
}
