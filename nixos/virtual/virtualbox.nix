{config, ...}: let
in {
  virtualisation = {
    virtualbox = {
      guest = {
        enable = false;
      };
      host = {
        enable = false;
      };
    };
  };
  users = {
    extraGroups = {
      vboxusers = {
        members = [
          "${config.name}"
        ];
      };
    };
  };
}
