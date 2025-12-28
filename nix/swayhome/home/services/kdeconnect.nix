{ pkgs, ... }: with pkgs; let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {

      # xdotdool to be able to close programs
      home.packages = [ xdotool];

      services = {
        kdeconnect = {
          enable = true;
          indicator = false;
        };
      };
    };
  };
}
