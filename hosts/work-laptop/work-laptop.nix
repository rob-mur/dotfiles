{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../options.nix
    ../../home/standalone.nix
  ];

  # Machine-specific option values (same style as NixOS hosts)
  machineType = "work-laptop";
  hostDir = "/home/robert.murphy/repos/dotfiles/hosts/work-laptop/";
  name = "robert.murphy";
  email = "robert.murphy@descartesunderwriting.com"; # Update this to your work email if different
  fullname = "Rob Murphy";
  version = "25.11";
  locale = "en_GB.UTF-8";
  timezone = "Europe/Paris";
  layout = "us_qwerty-fr";
  pass = "pass";
  group = "users";
  hostname = "work-laptop";
  autoLogin = false;

  # Home username is set from config.name by standalone.nix
  home.username = config.name;

  # Install home-manager itself for future rebuilds
  home.packages = with pkgs; [
    home-manager
  ];
}
