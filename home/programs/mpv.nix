{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
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
}
