{ ... }: let

  profile = import ./../../user/profile {};

in {
  services = {
    vsftpd = {
      enable = false;
      localUsers = true;
      writeEnable = true;
      userlist = [
       "${profile.name}"
      ];
    };
  };
}
