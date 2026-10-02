{pkgs, ...}: let
  # Claude Code draws a few symbols this font has to supply itself: the
  # bypass-permissions badge (U+23F5), the braille spinner, and assorted
  # warning/check/branch marks. On the NixOS host fontconfig hides any gap by
  # falling back across the ~60 installed font packages; Android's
  # Typeface.createFromFile() loads one file and does no fallback at all, so
  # here a missing glyph is simply a tofu box.
  #
  # DejaVu Sans Mono Nerd Font covers all of it except U+23F5, which is in no
  # font on this device - not any of the 208 in /system/fonts, and not any
  # Nerd Font cut checked (Fira Mono, Fira Code, DejaVu). Swapping fonts
  # cannot fix that one, so patch-font.py maps it (and four others) onto
  # glyphs the font already has. cmap-only: no outlines, no metric changes.
  #
  # nerd-fonts 3.4.0 in nixpkgs 26.05 ships DejaVu without the braille block,
  # which would leave the spinner broken - pkgs-unstable's 3.5.0 has it, the
  # same reason claude-code.nix tracks unstable.
  #
  # The result embeds no store paths, so the 32M base font is a build-time
  # dependency only and gets collected; what stays resident is one 2.7M file.
  claudeTerminalFont =
    pkgs.runCommand "dejavu-sans-mono-nf-claude" {
      nativeBuildInputs = [pkgs.python3Packages.fonttools pkgs.python3];
    } ''
      mkdir -p $out/share/fonts/truetype
      python3 ${./patch-font.py} \
        ${pkgs.pkgs-unstable.nerd-fonts.dejavu-sans-mono}/share/fonts/truetype/NerdFonts/DejaVuSansM/DejaVuSansMNerdFontMono-Regular.ttf \
        $out/share/fonts/truetype/DejaVuSansMNerdFontMono-Claude.ttf
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
  # This used to be nerd-fonts.fira-mono, matching the NixOS host
  # (nixos/system/fonts.nix), but Fira has neither U+23F5 nor the braille
  # block, so Claude Code's bypass-permissions badge and spinner were tofu.
  # The host only looks fine because fontconfig falls back for it; see the
  # claudeTerminalFont comment above. The app insists on the name
  # ~/.termux/font.ttf - that is fine, Android's font loader sniffs the file
  # format and ignores the extension. The "Mono" cut keeps every icon exactly
  # one cell wide, which is what a fixed terminal grid wants.
  terminal.font = "${claudeTerminalFont}/share/fonts/truetype/DejaVuSansMNerdFontMono-Claude.ttf";

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
