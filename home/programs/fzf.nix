{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
