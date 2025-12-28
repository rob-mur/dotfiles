{ ... }: let

  profile = import ./../../user/profile {};

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
        "${profile.name}"
        ];
      };
    };
  };
}
