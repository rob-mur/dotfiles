{
  lib,
  pkgs,
  ...
}: let
  # nix-on-droid's fixed user and home (not configurable by the app).
  home = "/data/data/com.termux.nix/files/home";

  machineConfig = {
    machineType = "phone";
    hostDir = "${home}/repos/dotfiles/hosts/phone/";
    name = "nix-on-droid";
    email = "rmurphyswimmer@gmail.com";
    gitEmail = "robert.murphy@descartesunderwriting.com";
    fullname = "Rob Murphy";
    version = "26.05";
    locale = "en_GB.UTF-8";
    timezone = "Europe/Paris";
    layout = "us_qwerty-fr";
    pass = "pass";
    group = "users";
    hostname = "phone";
    autoLogin = false;
    nvidiaForDisplay = false;
    enableSteam = false;
  };
in {
  # Same shared CLI set as the VM host (phone.nix), minus omnibin: it needs a
  # setuid fusermount3 and a systemd user service, neither of which exist
  # under nix-on-droid's proot.
  imports = [
    ../../options.nix
    ../../home/minimal.nix
  ];

  inherit
    (machineConfig)
    machineType
    hostDir
    name
    email
    fullname
    version
    locale
    timezone
    layout
    pass
    group
    hostname
    autoLogin
    nvidiaForDisplay
    enableSteam
    ;

  _module.args.osConfig = machineConfig;

  # minimal.nix assumes /home/<name>.
  home.username = lib.mkForce machineConfig.name;
  home.homeDirectory = lib.mkForce home;

  # Same as the VM host: git auth goes through gh's https token, so drop the
  # shared https->ssh rewrites and let gh serve credentials.
  programs.git.settings.url = lib.mkForce {};
  programs.git.settings.credential.helper = "!gh auth git-credential";

  programs.zsh.shellAliases.snrs = lib.mkForce "zsh -c 'cd ${machineConfig.hostDir} && nix-on-droid switch --flake .#default'";

  home.sessionVariables.LANG = "C.UTF-8";

  # Trim the shared oh-my-zsh plugin list to what this host can actually
  # use. Dropped: the cloud/container/python stack (none of those binaries
  # are installed here, so the plugins only contribute aliases for commands
  # that do not exist), emoji (the single most expensive non-git plugin at
  # ~120ms, purely decorative) and command-not-found (it wires a handler to
  # NixOS's /run/current-system/sw/bin/command-not-found, which this host
  # has no equivalent of). Every plugin also adds its directory to $fpath,
  # which is what compinit has to walk - see warmZcompdump below.
  programs.zsh.oh-my-zsh.plugins = lib.mkForce [
    "git"
    "aliases"
    "alias-finder"
    "branch"
    "copybuffer"
    "copyfile"
    "copypath"
    "dircycle"
    "git-auto-fetch"
    "git-prompt"
    "ssh"
    "sudo"
    "tmux"
  ];

  # Build zsh's completion dump during the switch rather than on first login.
  #
  # compinit caches ~2500 completion functions into a dump file, and has to
  # rebuild it whenever $fpath changes - which on Nix is every switch, since
  # $fpath is a list of store paths. Under nix-on-droid that rebuild means
  # ~2500 file reads through proot, i.e. a minute or more of a login shell
  # sitting there printing nothing. It reads as a hang, and Ctrl-C "fixes"
  # it by dropping you at a prompt - but Ctrl-C also aborts compinit before
  # it writes the dump, so the next launch rebuilds from scratch and hangs
  # again. That loop is why it happened at *every* boot and never settled.
  #
  # Doing it here pays the same cost once, unattended, at the end of a
  # switch that was already minutes long. `|| true` because a warm cache is
  # an optimisation, never a reason to fail an activation.
  #
  # NIX_PROFILES has to match what a login shell will see, because .zshrc
  # derives part of $fpath from it - and a dump built against a different
  # $fpath is one oh-my-zsh throws away on sight, which would leave the
  # rebuild back on the login it was meant to spare. It is normally
  # inherited from the shell that ran the switch; the fallback is the pair
  # nix-on-droid's own session-init exports.
  # PATH likewise: activation runs with a trimmed one, and .zshrc shells out
  # to awk, tmux and friends as it loads. Nothing there feeds the dump, so a
  # miss is harmless - but it prints "command not found" over the switch
  # output, which is noise that looks like breakage.
  home.activation.warmZcompdump = lib.hm.dag.entryAfter ["writeBoundary"] ''
    NIX_PROFILES="''${NIX_PROFILES:-/nix/var/nix/profiles/default ${home}/.nix-profile}" \
    PATH="${home}/.nix-profile/bin:$PATH" \
      run ${pkgs.zsh}/bin/zsh -ic exit || true
  '';
}
