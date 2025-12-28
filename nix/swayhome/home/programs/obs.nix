{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        obs-studio = {
          enable = false;
          plugins = with obs-studio-plugins; [
            obs-gstreamer
            obs-pipewire-audio-capture
            wlrobs
          ];
        };
      };
    };
  };
}
