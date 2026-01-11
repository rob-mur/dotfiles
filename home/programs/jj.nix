{
  pkgs,
  config,
  osConfig ? config,
  ...
}: let
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "${osConfig.fullname}";
        email = "${osConfig.email}";
      };
    };
  };

  home.packages = with pkgs; [
        lazyjj
      ];
}
