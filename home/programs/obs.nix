{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
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
}
