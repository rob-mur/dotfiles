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
      # Only trunk + tags are immutable. Feature branches (incl. their remote
      # bookmarks) stay rebasable without --ignore-immutable.
      revset-aliases."immutable_heads()" = "trunk() | tags()";
    };
  };

  home.packages = with pkgs; [
    jjui
  ];
}
