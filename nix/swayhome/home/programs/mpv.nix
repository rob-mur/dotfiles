{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  home-manager = {
    users.${config.name} = {
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

            save-position-on-quit = "yes";
            ytdl-format = "bestvideo+bestaudio";
          };
        };
      };
    };
  };
}
