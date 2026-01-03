{
  pkgs,
  ...
}:
with pkgs;
{
  security.polkit.enable = true;
  environment = {
    etc = {
      "greetd/environments".text = ''
        sway
        fish
        bash
      '';
    };
    unixODBCDrivers = with unixODBCDrivers; [
      mariadb
      psql
      sqlite
    ];
  };
}
