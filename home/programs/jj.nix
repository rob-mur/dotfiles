{
  pkgs,
  config,
  osConfig ? config,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "${osConfig.fullname}";
        email = "${osConfig.email}";
      };
      git.push-new-bookmarks = true;
      ui.allow-new = true;
    };
  };

  home.packages = with pkgs; [
    lazyjj
  ];
}
