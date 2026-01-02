{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        yt-dlp = {
          enable = true;
          settings = {
            downloader = "aria2c";
            downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
          };
        };
      };
    };
  };
}
