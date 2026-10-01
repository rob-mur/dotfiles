{
  lib,
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
}
