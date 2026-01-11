{
  config,
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  # Define config values that would normally come from NixOS
  machineConfig = {
    machineType = "work-laptop";
    hostDir = "/home/robert.murphy/repos/dotfiles/hosts/work-laptop/";
    name = "robert.murphy";
    email = "robert.murphy@descartesunderwriting.com";
    fullname = "Rob Murphy";
    version = "25.11";
    locale = "en_GB.UTF-8";
    timezone = "Europe/Paris";
    layout = "us_qwerty-fr";
    pass = "pass";
    group = "users";
    hostname = "work-laptop";
    autoLogin = false;
  };
in {
  imports = [
    ../../options.nix
    ../../home/standalone.nix
    ./desktopentries.nix
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

  # Pass machineConfig through _module.args so it's available as osConfig in submodules
  _module.args.osConfig = machineConfig;

  # Home username
  home.username = machineConfig.name;

  # Install home-manager itself for future rebuilds
  home.packages = with pkgs; [
    home-manager
  ];

  # Specific env vars just for work
  home.sessionVariables = {
    UV_KEYRING_PROVIDER = "subprocess";
    GOOGLE_CLOUD_PROJECT = "duet-assistant";
    GITLAB_API_TOKEN = "$(cat $HOME/.auth/gitlab_token)";
    GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
  };
}
