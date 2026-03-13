{
  config,
  pkgs,
  lib,
  ...
}: let
  baseVivaldi = pkgs.vivaldi.override {
    proprietaryCodecs = true;
    enableWidevine = true;
    commandLineArgs = "--disable-features=UseChromeOSDirectVideoDecoder --disable-setuid-sandbox";
  };

  wrappedVivaldi = pkgs.runCommand "vivaldi-wrapped" {
    buildInputs = [ pkgs.makeWrapper ];
    preferLocalBuild = true;
    # Preserve passthru and meta for home-manager
    passthru = baseVivaldi.passthru or {};
    meta = baseVivaldi.meta or {};
  } ''
    mkdir -p $out/bin
    mkdir -p $out/share

    # Link everything from the base package
    ln -s ${baseVivaldi}/share/* $out/share/ 2>/dev/null || true

    # Create wrapper script that adds dolphin to PATH and enables Wayland
    makeWrapper ${baseVivaldi}/bin/vivaldi $out/bin/vivaldi \
      --prefix PATH : ${lib.makeBinPath [ pkgs.kdePackages.dolphin pkgs.xdg-utils ]} \
      --set NIXOS_OZONE_WL "1"
  '';
in {
  programs.vivaldi = {
    enable = true;
    package = wrappedVivaldi;
  };

  # Override xdg-mime to point to dolphin for directories
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };
}
