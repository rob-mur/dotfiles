{config, ...}: let
in {
  programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
    };
  };
}
