{pkgs, ...}: {
  # nix-on-droid "system" side: the app's proot environment. There is no root,
  # systemd or FUSE here, so the system-manager half of the VM setup
  # (sshd.nix, droid-login.nix, setuid fusermount3 for omnibin) has no
  # equivalent; only the home-manager half carries over (nod-home.nix).
  system.stateVersion = "24.05";

  # nix-on-droid itself only ships bash, coreutils, less and nix, so the
  # basics every script (and oh-my-zsh, git, the wizard) expect have to be
  # listed explicitly. Kept here rather than in home-manager so they're on
  # PATH even if the home-manager activation fails.
  environment.packages = with pkgs; [
    # what wizard-nod.sh needs
    git
    curl
    openssh
    gh
    # standard userland a Debian box would have
    gnugrep
    gawk
    gnused
    findutils
    diffutils
    gnutar
    gzip
    xz
    bzip2
    unzip
    which
    file
    procps
    hostname
    iproute2
    ncurses # tput, clear
    man
    nano
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
