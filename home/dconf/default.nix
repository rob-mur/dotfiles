{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      dconf = {
        settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
    };
  };
}
