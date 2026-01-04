{config, ...}: let
in {
  programs = {
        msmtp = {
          enable = true;
    };
  };
}
