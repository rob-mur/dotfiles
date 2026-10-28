{pkgs, ...}: let
  # Claude Code draws a few symbols this font has to supply itself: the
  # bypass-permissions badge (U+23F5), the braille spinner, and assorted
  # warning/check/branch marks. On the NixOS host fontconfig hides any gap by
  # falling back across the ~60 installed font packages; Android's
  # Typeface.createFromFile() loads one file and does no fallback at all, so
  # here a missing glyph is simply a tofu box.
  #
  # Iosevka Nerd Font Mono (3.5.0+34.8.0) covers every codepoint Claude Code
  # draws, braille included, bar VS15 (U+FE0E). patch-font.py still runs: it
  # maps VS15 onto a zero-width glyph, and fails the build loudly if a future
  # Iosevka drops any of the others. cmap-only: no outlines, no metric changes.
  # DejaVu Sans Mono and Fira Mono, used before, lacked U+23F5 entirely.
  #
  # pkgs-unstable for the same reason claude-code.nix tracks unstable: nerd-fonts
  # 3.4.0 in nixpkgs 26.05 shipped DejaVu without the braille block, and the
  # phone should not lag the host's cut.
  #
  # The result embeds no store paths, so the base font package is a build-time
  # dependency only and gets collected; what stays resident is one ~14M file.
  claudeTerminalFont =
    pkgs.runCommand "iosevka-nf-claude" {
      nativeBuildInputs = [pkgs.python3Packages.fonttools pkgs.python3];
    } ''
      mkdir -p $out/share/fonts/truetype
      python3 ${./patch-font.py} \
        ${pkgs.pkgs-unstable.nerd-fonts.iosevka}/share/fonts/truetype/NerdFonts/Iosevka/IosevkaNerdFontMono-Regular.ttf \
        $out/share/fonts/truetype/IosevkaNerdFontMono-Claude.ttf
    '';
in {
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
  # This used to be nerd-fonts.fira-mono, then a patched DejaVu Sans Mono;
  # it now matches the host's `theme.font-mono` (Iosevka), so a session ssh'd
  # in from the phone looks the same as one in kitty. See the
  # claudeTerminalFont comment above for why it is patched. The app insists
  # on the name ~/.termux/font.ttf - that is fine, Android's font loader
  # sniffs the file format and ignores the extension. The "Mono" cut keeps every icon exactly
  # one cell wide, which is what a fixed terminal grid wants.
  terminal.font = "${claudeTerminalFont}/share/fonts/truetype/IosevkaNerdFontMono-Claude.ttf";

  # ...so a font or colour change can be applied with
  # `termux-reload-settings` instead of killing every session.
  android-integration.termux-reload-settings.enable = true;

  # URLs from the desktop open here: herdr-desk's bridge listener opens them
  # with termux-open-url, and herdr's own Ctrl-click runs xdg-open in the
  # client, which is this phone. nix-on-droid provides neither by default,
  # and without them both fail silently. Copying needs nothing here: the
  # desktop sends OSC 52 for the terminal to apply.
  android-integration.termux-open-url.enable = true;
  android-integration.xdg-open.enable = true;

  # The app owns the login shell, so no Debian-style bash -> zsh exec dance.
  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    config = ./nod-home.nix;
  };
}
