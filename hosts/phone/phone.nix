{
  config,
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  # Define config values that would normally come from NixOS
  machineConfig = {
    machineType = "phone";
    hostDir = "/home/droid/repos/dotfiles/hosts/phone/";
    name = "droid";
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
  imports = [
    ../../options.nix
    ../../home/minimal.nix
  ];

  # Set the option values
  machineType = machineConfig.machineType;
  hostDir = machineConfig.hostDir;
  name = machineConfig.name;
  email = machineConfig.email;
  fullname = machineConfig.fullname;
  version = machineConfig.version;
  locale = machineConfig.locale;
  timezone = machineConfig.timezone;
  layout = machineConfig.layout;
  pass = machineConfig.pass;
  group = machineConfig.group;
  hostname = machineConfig.hostname;
  autoLogin = machineConfig.autoLogin;
  nvidiaForDisplay = machineConfig.nvidiaForDisplay;
  enableSteam = machineConfig.enableSteam;

  # Pass machineConfig through _module.args so it's available as osConfig in submodules
  _module.args.osConfig = machineConfig;

  # Home username
  home.username = machineConfig.name;

  # Install home-manager itself for future rebuilds
  home.packages = with pkgs; [
    home-manager
  ];

  # The shared alias set assumes a NixOS host (`snrs` runs nixos-rebuild
  # against a system flake). This is standalone home-manager only, so point
  # it at `home-manager switch` instead. Overriding at the programs.zsh level
  # (not home.shellAliases) avoids colliding with zsh.nix's own assignment.
  programs.zsh.shellAliases.snrs = lib.mkForce "zsh -c 'cd ${machineConfig.hostDir} && home-manager switch --flake .#dev'";
}
