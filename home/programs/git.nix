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
        git = {
          enable = true;
          settings = {
            user = {
              email = "${config.email}";
              name = "${config.fullname}";
            };
            init = {
              defaultBranch = "main";
            };
            pull = {
              rebase = true;
            };
            core = {
              editor = "${helix}/bin/hx";
              whitespace = "trailing-space,space-before-tab";
            };
            alias = {
              ad = "add";
              br = "branch";
              cm = "commit";
              co = "checkout";
              df = "diff";
              fe = "fetch";
              lg = "log";
              mr = "merge";
              pl = "pull";
              ps = "push";
              rt = "remote";
              st = "status";
              sw = "switch";
              tg = "tag";
            };
            url = {
              "git@git.sr.ht:" = {
                insteadOf = [
                  "https://git.sr.ht/"
                ];
              };
              "git@github.com:" = {
                insteadOf = [
                  "https://github.com/"
                ];
              };
              "git@gitlab.com:" = {
                insteadOf = [
                  "https://gitlab.com/"
                ];
              };
            };
          };

          lfs = {
            enable = true;
          };
          ignores = [
            "*~"
            "*.swp"
          ];
        };
      };
    };
  };
}
