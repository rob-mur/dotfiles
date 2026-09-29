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
    ../../home/programs/omnibin.nix
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

  # Install home-manager and system-manager themselves for future rebuilds.
  # gh is installed for real (not left to omnibin): agents and scripts call
  # it by name, and omnibin binaries only resolve inside `omni`'s namespace.
  home.packages = with pkgs; [
    home-manager
    system-manager
    gh
  ];

  # The shared alias set assumes a NixOS host (`snrs` runs nixos-rebuild
  # against a system flake). This is standalone home-manager (which also
  # applies the system-manager half, see system.nix), so point it at
  # `home-manager switch` instead. Overriding at the programs.zsh level (not
  # home.shellAliases) avoids colliding with zsh.nix's own assignment.
  programs.zsh.shellAliases.snrs = lib.mkForce "zsh -c 'cd ${machineConfig.hostDir} && home-manager switch --flake .#dev'";

  # The login shell is Debian's /usr/bin/bash, and changing it needs root
  # (chsh + /etc/shells), so bash hands interactive sessions straight to the
  # home-manager zsh instead. Non-interactive bash (scripts, scp) and `bash -ic ...` are untouched.
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* && -z $BASH_EXECUTION_STRING && -z $ZSH_VERSION && -x ${config.programs.zsh.package}/bin/zsh ]]; then
        exec ${config.programs.zsh.package}/bin/zsh -l
      fi
    '';
    # Unknown commands fall through to omni, so anything in the omnibin tree
    # works by name — nobody (person, script, or agent) has to know to type
    # `omni gh`. Lives in bashrcExtra, ahead of the interactive-only guard,
    # so non-interactive agent shells get it too.
    bashrcExtra = ''
      command_not_found_handle() {
        if command -v omni >/dev/null 2>&1; then
          omni "$@"
        else
          printf 'bash: %s: command not found\n' "$1" >&2
          return 127
        fi
      }
    '';
  };

  # Same fallback for the interactive zsh sessions.
  programs.zsh.initContent = lib.mkAfter ''
    command_not_found_handler() {
      if command -v omni >/dev/null 2>&1; then
        omni "$@"
      else
        printf 'zsh: command not found: %s\n' "$1" >&2
        return 127
      fi
    }
  '';

  # Debian sets LANG=C.UTF-8 via PAM (/etc/default/locale), but sessions
  # that skip PAM — the system-manager sshd, and therefore any tmux server
  # started from one — get no locale at all. tmux clients attached from a
  # POSIX locale render every non-ASCII glyph as "_" (icons, powerline,
  # unicode names). Export it from hm-session-vars so every login shell,
  # including the one that launches or attaches tmux, is UTF-8. C.UTF-8 is
  # built into both Debian's and nixpkgs' glibc, unlike ${machineConfig.locale}
  # which this Debian host hasn't generated.
  home.sessionVariables.LANG = "C.UTF-8";

  # tmux starts panes as login shells but copies the launching shell's
  # environment, including the "already sourced" guards of Nix's and
  # home-manager's profile scripts. Debian's /etc/profile then resets PATH
  # and both scripts skip re-adding ~/.nix-profile/bin. Dropping the guards
  # from tmux's environment lets each pane build PATH like a fresh login.
  # LANG is also pinned in the server's global environment so panes of a
  # server that predates the session-vars fix still come up UTF-8.
  programs.tmux.extraConfig = lib.mkAfter ''
    set-environment -gu __HM_SESS_VARS_SOURCED
    set-environment -gu __ETC_PROFILE_NIX_SOURCED
    set-environment -g LANG C.UTF-8
  '';
}
