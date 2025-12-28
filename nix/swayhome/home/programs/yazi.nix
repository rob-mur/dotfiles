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
        yazi = {
          enable = false;
          settings = {
            log = {
              enabled = false;
            };
            mgr = {
              ratio = [2 4 3];
              show_hidden = false;
              sort_by = "alphabetical";
              linemode = "size";
              sort_dir_first = true;
              sort_reverse = false;
            };
            preview = {
              tab_size = 4;
              image_filter = "nearest";
              max_width = 1920;
              max_height = 1080;
              image_quality = 90;
            };
            opener = {
              edit = [
                {
                  run = ''$EDITOR "$@"'';
                  block = true;
                  desc = "edit";
                  for = "unix";
                }
              ];
              compress-zip = [
                {
                  run = ''${ouch}/bin/ouch compress "$@" "$@.zip"'';
                  desc = "compress zip";
                  for = "unix";
                }
              ];
              compress-gzip= [
                {
                  run = ''${ouch}/bin/ouch compress "$@" "$@.tar.gz"'';
                  desc = "compress tar.gz";
                  for = "unix";
                }
              ];
              open = [
                {
                  run = ''${xdg-utils}/bin/xdg-open "$@"'';
                  desc = "open";
                  for = "linux";
                }
              ];
              reveal = [
                {
                  run = ''${xdg-utils}/bin/xdg-open $(dirname "$1")'';
                  desc = "reveal";
                  for = "linux";
                }
              ];
              extract = [
                {
                  run = ''${ouch}/bin/ouch decompress "$@"'';
                  desc = "extract";
                  for = "unix";
                }
              ];
              play = [
                {
                  run = ''${mpv}/bin/mpv "$@"'';
                  orphan = true;
                  desc = "play";
                  for = "unix";
                }
              ];
            };
            open = {
              rules = [
                {
                  name = "*/";
                  use = [
                    "edit"
                    "compress-zip"
                    "compress-gzip"
                    "open"
                  ];
                }
                {
                  mime = "text/*";
                  use = [
                    "edit"
                  ];
                }
                {
                  mime = "image/*";
                  use = [
                    "open"
                  ];
                }
                {
                  mime = "{audio,video}/*";
                  use = [
                    "play"
                  ];
                }
                {
                  name = "*.kra";
                  use = [
                    "open"
                  ];
                }
                {
                  name = "*.blend";
                  use = [
                    "open"
                  ];
                }
                {
                  mime = "application/{json,ndjson}";
                  use = [
                    "edit"
                  ];
                }
                {
                  mime = "*/javascript";
                  use = [
                    "edit"
                  ];
                }
                {
                  mime = "inode/empty";
                  use = [
                    "edit"
                  ];
                }
                {
                  mime = "application/pdf";
                  use = [
                    "open"
                  ];
                }
                {
                  mime = "application/epub+zip";
                  use = [
                    "open"
                  ];
                }
                {
                  mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
                  use = [
                    "extract"
                    "open"
                    "encrypt"
                  ];
                }
                {
                  name = "*";
                  use = [
                    "edit"
                    "play"
                    "encrypt"
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
