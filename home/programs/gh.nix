{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  programs = {
        gh = {
          enable = false;
          settings = {
            editor = "${helix}/bin/hx";
            git_protocol = "ssh";
      };
    };
  };
}
