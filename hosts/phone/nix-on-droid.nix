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

  # The app ships a plain monospace font with no Nerd Font glyph range, so
  # every icon in the prompt, eza and btop rendered as a replacement box.
  # Use the same Nerd Font the NixOS host installs (nixos/system/fonts.nix).
  # Two details worth knowing: the package only ships OTF, and the app
  # insists on the name ~/.termux/font.ttf - that is fine, Android's font
  # loader sniffs the file format and ignores the extension. The "Mono" cut
  # keeps every icon exactly one cell wide, which is what a fixed terminal
  # grid wants.
  terminal.font = "${pkgs.nerd-fonts.fira-mono}/share/fonts/opentype/NerdFonts/FiraMono/FiraMonoNerdFontMono-Regular.otf";

  # ...so a font or colour change can be applied with
  # `termux-reload-settings` instead of killing every session.
  android-integration.termux-reload-settings.enable = true;

  # The app owns the login shell, so no Debian-style bash -> zsh exec dance.
  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    config = ./nod-home.nix;
  };
}
