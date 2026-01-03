{
  pkgs,
  config,
  ...
}: let
in {
  home-manager = {
    users.${config.name} = {
      home.packages = with pkgs; [
        jujutsu
        lazyjj
      ];
    };
  };
}
