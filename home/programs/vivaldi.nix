{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    };
    commandLineArgs = [
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-setuid-sandbox"
    ];
  };

  # Ensure xdg-utils is available for Vivaldi to find dolphin
  home.packages = with pkgs; [
    xdg-utils
  ];

  # Override xdg-mime to point to dolphin for directories
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };
}
