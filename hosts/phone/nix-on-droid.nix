{pkgs, ...}: {
  # nix-on-droid "system" side: the app's proot environment. There is no root,
  # systemd or FUSE here, so the system-manager half of the VM setup
  # (sshd.nix, droid-login.nix, setuid fusermount3 for omnibin) has no
  # equivalent; only the home-manager half carries over (nod-home.nix).
  system.stateVersion = "24.05";

  # Base tools present even before / outside home-manager.
  environment.packages = with pkgs; [
    git
    curl
    openssh
    gh
  ];

  # Phones have little RAM; one build at a time avoids the OOM killer.
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    max-jobs = 1
  '';

  time.timeZone = "Europe/Paris";

  # The app owns the login shell, so no Debian-style bash -> zsh exec dance.
  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    config = ./nod-home.nix;
  };
}
