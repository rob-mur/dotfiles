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
