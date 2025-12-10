{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # Assuming this is in the root
  ];

  # --- Boot & Hardware ---
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.grub.useOSProber = true;
  boot.kernelModules = ["nouveau"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # --- Networking ---
  networking.hostName = "dev";
  networking.networkmanager.enable = true;
  networking.interfaces.enp4s0.wakeOnLan.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
  };

  # --- Locale ---
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
  };

  # --- Services ---
  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.pdf.settings = {
        Out = "\${HOME}/Downloads";
        UserUMask = "0033";
      };
    };
  };

  services.pipewire.enable = false;
  services.pulseaudio.enable = true;
  services.pulseaudio.package = pkgs.pulseaudioFull;
  services.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  programs.dconf.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rob";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # --- Nix Settings ---
  nixpkgs.config.allowUnfreePredicate = pkg: let
    name = lib.getName pkg;
  in
    lib.any (p: name == p || lib.hasPrefix "${p}-" name) [
      "vscode"
      "google-chrome"
      "signal-desktop-bin"
      "slack"
      "spotify"
      "davinci-resolve"
      "teamviewer"
      "discord"
      "ticktick"
      "postman"
      "reaper"
      "steam"
      "obsidian"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "nvidia-x11"
      "nvidia-settings"
      "vivaldi"
    ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      auto-optimise-store = true;
      max-jobs = 4;
      cores = 2;
      trusted-users = ["root" "rob"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-14d";
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # --- Users ---
  users.users.rob = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "vboxusers" "networkmanager"];
    useDefaultShell = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # --- System Packages ---
  # Only keeping core system tools here.
  # User apps are now in home-manager below.
  environment.systemPackages = with pkgs; [
    lshw
    xdotool
    exfatprogs
    wireguard-tools
    protonvpn-gui
    paprefs
    qpwgraph
    ethtool
    wdisplays
    kdePackages.kate
    kdePackages.kolourpaint
    kdePackages.kcalc
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde

    # Keeping rclone/mount logic deps here
    rclone
  ];

  environment.variables = {
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_NO_VENDER = "1";
    OPENSSL_LIB_DIR = "${pkgs.lib.getLib pkgs.openssl}/lib";
  };

  # --- Programs ---
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
  };
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  programs.ssh.startAgent = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.teamviewer.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us_qwerty-fr";
      extraLayouts.us_qwerty-fr = {
        description = "Qwerty-fr";
        languages = ["eng" "fra"];
        symbolsFile = "${pkgs.qwerty-fr}/share/X11/xkb/symbols/us_qwerty-fr";
      };
    };
  };
  console.useXkbConfig = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  virtualisation.docker.enable = true;

  # Systemd service for rclone
  systemd.services.rclone-onedrive = {
    description = "Rclone mount for OneDrive";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "rob";
      ExecStart = "${pkgs.rclone}/bin/rclone --config /home/rob/Documents/nixos-config/dotfiles/rclone.conf mount onedrive: /home/rob/Documents/OneDrive --vfs-cache-mode full --vfs-read-chunk-size 128M -v --allow-non-empty";
      Restart = "always";
      ExecStop = "${pkgs.util-linux}/bin/umount -l /home/rob/Documents/OneDrive/";
    };
  };

  system.stateVersion = "23.05";

  # --- INTEGRATED HOME MANAGER ---
  home-manager.users.rob = {pkgs, ...}: {
    # 1. IMPORT WORK CONFIG (The "Base")
    imports = [../dev-module.nix];

    # 2. ADD HOME EXTENSIONS (The "Delta")
    home.packages = with pkgs; [
      # Browsers & Communication
      firefox
      (google-chrome.override {commandLineArgs = ["--password-store=basic"];})
      signal-desktop-bin
      discord
      slack

      # Media & Creative
      spotify
      vlc
      ffmpeg
      obs-studio
      gimp-with-plugins
      inkscape
      darktable
      davinci-resolve
      reaper
      mixxx
      spotdl
      yt-dlp
      mediainfo

      # Tools & Productivity
      vscode
      obsidian
      ticktick
      postman
      filezilla
      keepassxc
      anki

      # System Utilities
      baobab
      p7zip
      zip
      unzip
      killall
      nerd-fonts.fira-code

      # Gaming / Wine
      winetricks
      protontricks

      # Using the Overlay defined in Flake.nix
      r2305.yuzu-mainline
    ];

    programs.alacritty.enable = true;

    programs.git = {
      enable = true;
      userName = "Rob Murphy";
      userEmail = "rmurphyswimmer@gmail.com";
    };
  };
}
