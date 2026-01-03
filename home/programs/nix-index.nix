{config, ...}: let
in {
  programs = {
        nix-index = {
          enable = false;
          enableFishIntegration = true;
    };
  };
}
