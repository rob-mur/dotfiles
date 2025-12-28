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
        mpv = {
          enable = true;
          scripts = with mpvScripts; [
            mpris
            mpv-cheatsheet
          ];
          config = {
            force-window = "yes";
            fullscreen = "no";
            osc = "yes";
            profile = "gpu-hq";
            save-position-on-quit = "yes";
            ytdl-format = "bestvideo+bestaudio";
          };
        };
      };
    };
  };
}
