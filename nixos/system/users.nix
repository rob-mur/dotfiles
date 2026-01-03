{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = zsh;
    users = {
      ${config.name} = {
        isNormalUser = true;
        description = "${config.fullname}";
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
