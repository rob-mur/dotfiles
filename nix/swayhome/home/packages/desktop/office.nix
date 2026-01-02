{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
      home = {
        packages = [
          libreoffice
          tipp10
          zotero
        ];
      };
    };
  };
}
