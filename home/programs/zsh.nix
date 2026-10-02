{
  pkgs,
  config,
  osConfig ? config,
  ...
}:
with pkgs; let
  abbr = import ./../../user/abbr {config = osConfig;};
  plugins = import ../config/zsh/plugins.nix;
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = abbr.abbr;
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      inherit plugins;
      # oh-my-zsh already calls `compinit -i`, i.e. "load completions from
      # insecure directories anyway", so compaudit only decides whether to
      # print a warning nothing acts on - and to decide that it stats every
      # one of the ~2500 files in $fpath. That was 40% of an interactive zsh
      # start (2.4s of 6s on the phone). What it flags here is the Nix store
      # being root-owned, which is the point of the Nix store.
      extraConfig = ''
        ZSH_DISABLE_COMPFIX=true
      '';
    };
    # Terminals spawned outside a logind login (e.g. the Android VM) miss
    # pam_systemd's exports; systemctl --user / busctl need them. Guarded so
    # hosts with a proper login session are untouched.
    envExtra = ''
      if [[ -z "$XDG_RUNTIME_DIR" && -d "/run/user/$UID" ]]; then
        export XDG_RUNTIME_DIR="/run/user/$UID"
      fi
      if [[ -z "$DBUS_SESSION_BUS_ADDRESS" && -S "$XDG_RUNTIME_DIR/bus" ]]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      fi
    '';

    # --- 3. Custom Startup Scripts & Init ---
    initContent = ''
      # Source a local file if it exists
      [[ -f ~/.local_zshrc ]] && source ~/.local_zshrc

      # Setup nvim as editor
      bindkey -v
      # `bind` is bash's readline builtin and has never existed in zsh; these
      # three lines were dead, their error hidden by the 2>/dev/null. Removed
      # rather than left alone because with a command-not-found handler
      # installed (programs/autobin.nix) an unknown command is no longer free:
      # each one costs a package resolution on every interactive shell start.
      bindkey '^x^e' edit-command-line
      export EDITOR=nvim
    '';

    # --- 4. Extra Non-OMZ Plugins ---
    plugins = [
      {
        name = "zsh-system-clipboard";
        file = "zsh-system-clipboard.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "kutsan";
          repo = "zsh-system-clipboard";
          rev = "v0.8.0";
          sha256 = "sha256-VWTEJGudlQlNwLOUfpo0fvh0MyA2DqV+aieNPx/WzSI=";
        };
      }
    ];
  };

  home.sessionVariables = {
    ZSH_SYSTEM_CLIPBOARD_USE_WL_CLIPBOARD = "true";
  };
}
