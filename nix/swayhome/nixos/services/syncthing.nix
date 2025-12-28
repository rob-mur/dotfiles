{ ... }: let

  profile = import ./../../user/profile {};

in {
  services = {
    syncthing = {
      enable = false;
      user = "${profile.hostname}";
      group = "users";
      dataDir = "/home/${profile.hostname}/documents";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        gui = {
          theme = "dark";
        };
        options = {
          localAnnounceEnabled = false;
          urAccepted = -1;
        };
      };
    };
  };
}
