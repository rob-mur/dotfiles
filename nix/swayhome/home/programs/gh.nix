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
        gh = {
          enable = false;
          settings = {
            editor = "${helix}/bin/hx";
            git_protocol = "ssh";
          };
        };
      };
    };
  };
}
