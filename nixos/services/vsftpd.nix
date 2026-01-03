{config, ...}: let
in {
  services = {
    vsftpd = {
      enable = false;
      localUsers = true;
      writeEnable = true;
      userlist = [
        "${config.name}"
      ];
    };
  };
}
