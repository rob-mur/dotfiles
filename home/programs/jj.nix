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
      ui.merge-editor = "nvimdiff";
      merge-tools.nvimdiff = {
        program = "nvim";
        merge-args = [
          "-d"
          "$left"
          "$base"
          "$right"
          "$output"
          "-c"
          "wincmd J | wincmd ="
        ];
      };
    };
  };

  home.packages = with pkgs; [
    jjui
  ];
}
