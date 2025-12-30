{pkgs, ...}:
with pkgs; let
  profile = import ./../../user/profile {};
in {
  home-manager = {
    users.${profile.name} = {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };
  };
}
