{
  config,
  pkgs,
  lib,
  ...
}: let
  baseVivaldi = pkgs.vivaldi.override {
    proprietaryCodecs = true;
    enableWidevine = true;
  };

  wrappedVivaldi = baseVivaldi.overrideAttrs (oldAttrs: {
    buildCommand = oldAttrs.buildCommand or "" + ''
      # Add dolphin and xdg-utils to the wrapper's PATH
      sed -i "s|^exec|export PATH=\"${lib.makeBinPath [ pkgs.kdePackages.dolphin pkgs.xdg-utils ]}:\$PATH\"\nexec|" $out/bin/vivaldi
    '';
  });
in {
  programs.vivaldi = {
    enable = true;
    package = wrappedVivaldi;
    commandLineArgs = [
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-setuid-sandbox"
    ];
  };

  # Override xdg-mime to point to dolphin for directories
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };
}
