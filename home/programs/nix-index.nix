{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        nix-index = {
          enable = false;
          enableFishIntegration = true;
        };
      };
    };
  };
}
