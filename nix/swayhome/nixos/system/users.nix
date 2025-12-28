{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = zsh;
    users = {
      ${profile.name} = {
        isNormalUser = true;
        description = "${profile.fullname}";
        uid = 1000;
        extraGroups = [
          "adbusers"
          "audio"
          "disk"
          "docker"
          "input"
          "libvirtd"
          "lp"
          "mysql"
          "postgres"
          "systemd-journal"
          "users"
          "video"
          "wheel"
          "ydotool"
          "networkmanager"
        ];
      };
    };
  };
}
