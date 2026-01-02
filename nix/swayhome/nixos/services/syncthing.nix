{config, ...}: let
in {
  services = {
    syncthing = {
      enable = false;
      user = "${config.hostname}";
      group = "users";
      dataDir = "/home/${config.hostname}/documents";
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
