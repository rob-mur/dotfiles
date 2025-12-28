{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
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
