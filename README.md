# Swayhome

This is the [`NixOS`] configuration repository. Include [`Sway WM`] and [Home Manager] configuration.

## 🐬 Gallery

![image-gallery1]
![image-gallery2]

Uniform look for `GTK2/3/4` and `QT5/6` applications with Dark Mode (Breeze-Dark theme from [`KDE`]).

![image-gallery3]
![image-gallery4]

## 💠 File structure

- [Home](./home) : Home-manager configuration.
  - [Config](./home/config) : List of user configuration directory (~/.config).
  - [`Dconf`](./home/dconf) : List of user `Dconf` settings.
  - [Fonts](./home/fonts) : List of user fonts config.
  - [Packages](./home/packages) : List of user packages without configuration.
  - [Programs](./home/programs) : List of user packages with configuration.
  - [Services](./home/services) : List of user services.
  - [Theme](./home/theme) : List of user themes.
  - [Wayland](./home/wayland) : Window manager configuration (sway).
  - [`XDG`](./home/xdg) : Manage mime apps and `user-dirs`.
- [`NixOS`](./nixos) : System configuration.
  - [Hardware](./nixos/hardware) : List of hardware configuration.
  - [Programs](./nixos/programs) : List of programs installed through the system.
  - [Services](./nixos/services) : List of system services.
  - [System](./nixos/system) : List of system settings.
  - [Theme](./nixos/theme) : List of system themes.
  - [Virtual](./nixos/virtual) : Isolation environments and virtual machines.
- [Asset](./asset) : List of screenshots, wallpapers, video, and so on.

## 💎 List of apps

| Category          | Name                  | Alternative  | Description                                                 |
| :---------------- | :-------------------- | :----------- | :---------------------------------------------------------- |
| Audio player      | `ncmpcpp`+`mpd`       |              | `Ncurses` based `mpd` client.                               |
| Brightness        | `light`               | `swayosd`    | Application to control brightness.                          |
| Battery daemon    | `batsignal`           |              | Lightweight battery daemon written in `C`.                  |
| Bluetooth         | `rofi`+`bluetoothctl` | `bluetuith`  | Interface to connect to Bluetooth devices.                  |
| Browser           | `qutebrowser`         | `firefox`    | Keyboard-focused browser.                                   |
| Display settings  | `wdisplay`            |              | Configuring displays in Wayland compositor.                 |
| Dynamic wallpaper | `wpaperd`             |              | Minimal wallpaper daemon for Wayland.                       |
| Email client      | `aerc`                |              | Email client for terminal.                                  |
| File manager      | `joshuto`             |              | Ranger-like terminal file manager.                          |
| Fonts             | `fira-sans:10`        |              | Minimalist sans font.                                       |
| `GTK2/3/4` theme  | `breeze-dark`         |              | Design language of the `KDE` plasma desktop environment.    |
| Icons             | `papirus-icon-theme`  |              | Pixel perfect icon theme for Linux.                         |
| Image viewer      | `imv`                 | `krita`      | Command line image viewer.                                  |
| Login manager     | `greetd`              |              | Minimal and flexible login manager daemon.                  |
| Menu              | `rofi`                | `wofi`       | Window switcher, run dialog and `dmenu` replacement.        |
| Notification      | `mako`                |              | Lightweight Wayland notification daemon.                    |
| PDF viewer        | `zathura`             |              | Highly customizable and functional PDF viewer.              |
| Panel Bar         | `waybar`              |              | Customizable Wayland bar for sway.                          |
| Password store    | `rofi`+`pass`         |              | Stores, retrieves, generates, and synchronizes passwords.   |
| Pick color        | `wl-color-picker`     |              | Wayland color picker that also works on `Wlroots`.          |
| `QT5/6` theme     | `breeze-dark`         |              | Style to bend Qt applications to look like `KDE` plasma.    |
| Screen lock       | `swaylock`            |              | Screen locker for Wayland.                                  |
| Screen recorder   | `wl-screenrec`        | `obs-studio` | Screen recording of `Wlroots`-based.                        |
| Shell             | `fish`                | `bash`       | Smart and user-friendly command line shell.                 |
| System check      | `bottom`              | `htop`       | Graphical process/system check.                             |
| Terminal          | `kitty`               |              | Minimalist Wayland terminal emulator.                       |
| Terminal session  | `zellij`              | `tmux`       | Terminal workspace with batteries included.                 |
| Text editor       | `helix`               | `neovim`     | Post-modern modal text editor.                              |
| Video player      | `mpv`                 |              | General-purpose media player.                               |
| Volume control    | `pamixer`             | `pulsemixer` | Command line mixer.                                         |
| Window manager    | `sway`                |              | Tiling Wayland compositor.                                  |

## 🐳 Sway usage

| Key binding                   | Next key                          | Description                                                           |
| :---------------------------- | :-------------------------------- | :-------------------------------------------------------------------- |
| `Mod`                         |                                   | Meta key with logo (`mod4`).                                          |
| `Mod` + `Number`              |                                   | Move to workspace (`num=1-9`).                                        |
| `Mod` + `Enter`               |                                   | Terminal (foot).                                                      |
| `Mod` + `h` / `j` / `k` / `l` |                                   | Focus to window.                                                      |
| `Mod` + `d`                   |                                   | Application launcher (`rofi`).                                        |
| `Mod` + `y`                   |                                   | Bluetooth launcher (`rofi`).                                          |
| `Mod` + `c`                   |                                   | Clipboard manager (`rofi`).                                           |
| `Mod` + `e`                   |                                   | Password store (`rofi`).                                              |
| `Mod` + `m`                   |                                   | Pick emoji for Wayland.                                               |
| `Mod` + `n`                   |                                   | Pick-color code for Wayland.                                          |
| `Mod` + `o`                   |                                   | Wayland output mirror client.                                         |
| `Mod` + `f`                   |                                   | Full-screen window.                                                   |
| `Mod` + `u`                   | `i` / `o`                         | Set sink (input) and source (output) audio.                           |
| `Mod` + `p`                   | `1-3` / `4-6` / `7-9`             | Configuring screen with `wlr-randr`.                                  |
| `Mod` + `r`                   | `h` / `j` / `k` / `l`             | Resize window apps.                                                   |
| `Mod` + `x`                   | `h` / `p` / `r` / `s` / `l` / `o` | Hibernate, power off, reboot, suspend, lock screen and log out.       |
| `Print`                       | `1` / `2` / `3` / `4`             | Print screen area, all, area (copy) and all (copy).                   |
| `Shift` + `Print`             | `1` / `2` / `3` / `4` / `0`       | Recording area, all, area (no audio), all (no audio) and stop record. |

## 🫐 Installation

### Cloning repository

#### Read and write (recommended):

| Repository   | Command                                     |
| :----------- | :------------------------------------------ |
| `Sourcehut`  | `git clone git@git.sr.ht:~hervyqa/swayhome` |

#### Read-only:

| Repository   | Command                                         |
| :----------- | :---------------------------------------------- |
| `Sourcehut`  | `git clone https://git.sr.ht/~hervyqa/swayhome` |

```sh
cd swayhome
```

### Symbolic link configuration

```sh
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
sudo ln -s $PWD/configuration.nix /etc/nixos/
```

### Switch channel

Using **Stable Channel** version, home-manager also using the same version. Make sure the system and home-manager also use the same version.

#### Stable channel

| Channel        | Version  | Command                                                                                                          |
| :------------- | :------- | :--------------------------------------------------------------------------------------------------------------- |
| `NixOS`        | 25.11    | `sudo nix-channel --add https://channels.nixos.org/nixos-25.11 nixos`                                            |
| `home-manager` | 25.11    | `sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager` |

#### Unstable channel (bleeding edge)

| Channel        | Version  | Command                                                                                                          |
| :------------- | :------- | :--------------------------------------------------------------------------------------------------------------- |
| `NixOS`        | unstable | `sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos`                                         |
| `home-manager` | unstable | `sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`        |

Then, update channel.

```sh
sudo nix-channel --update
```

If using a different version, replace `version` variables from [profile].

## 🧢 User variable

Some variables in the [profile]. You need to replace it with another name and value. For example:

```nix
name = "hervyqa";
email = "hervyqa@xxxxxxx.xxx";
fullname = "Hervy Qurrotul Ainur Rozi";
signingkey = "D7B52C04D9B40738";
timezone = "Asia/Jakarta";
defaultlocale = "en_US.UTF-8";
extralocale = "id_ID.UTF-8";
hostname = "nixos";
layout = "us";
version = "25.05";
```

## 💙 Configure hardware

If you are installing `NixOS` for the first time, there is a `hardware-configuration.nix` file, you can change variables and include each existing module in `dotfiles` settings. You do not need to take all the settings such as these `dotfiles`, just take the part you need.

### Processor

You can change it if you use another processor such as `amd` or `intel`. Nix file: [processor.nix].

```nix
hardware = {
  cpu = {
    # amd or intel
    amd = {
      updateMicrocode =
       lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
};
```

### File systems

Change device ID of `/`, `/home` and `/boot` partition. Nix file: [partition.nix].

```nix
fileSystems = {
  "/" = {
    device = "/dev/disk/by-uuid/56f0a8d0-7c8b-4849-9d18-def00c2a7b47";
    fsType = "ext4";
  };
  "/home" = {
    device = "/dev/disk/by-uuid/7403caac-87c5-46c4-896e-bc74a3ba8b95";
    fsType = "ext4";
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/ABD9-665E";
    fsType = "vfat";
  };
};
```

### Swap partition

If you have a Swap Linux partition (optional). Nix file: [swapdevices.nix].

```nix
swapDevices = [];
```

## 🗳 How to build

This `dotfiles` installed with the `NixOS` module. No need to run `home-manager switch` because the system and user configuration built together.

```sh
sudo nixos-rebuild switch
```

For next build, prefer using `doas` as an alternative to `sudo`.

```sh
doas nixos-rebuild switch
```

You can use `dnrs` from shell prompt aliases.

Nix file: [abbr.nix].

```sh
dnrs
```

## 🌊 Check system

```sh
nix-shell -p nix-info --run 'nix-info -m'
```

Sample output.

```
- system: `"x86_64-linux"`
- host os: `Linux 6.6.87-rt54, NixOS, 25.05 (Warbler), 25.05.802216.55d1f923c480`
- multi-user?: `yes`
- sandbox: `yes`
- version: `nix-env (Nix) 2.28.3`
- channels(root): `"home-manager-25.05.tar.gz, nixos-25.05"`
- nixpkgs: `/nix/store/5zf6dmmp2pqg6dyjr32yb6gldnhg13rv-nixos-25.05/nixos`
```

## 📘 License

Massachusetts International Technology (MIT) License

[`NixOS`]:https://nixos.org
[`Sway WM`]:https://swaywm.org
[Home Manager]:https://nix-community.github.io/home-manager
[`KDE`]:https://develop.kde.org/hig/style/color/dark

[image-gallery1]:./asset/gallery/20240622_04h50m26s_@hervyqa.png
[image-gallery2]:./asset/gallery/20240622_04h51m19s_@hervyqa.png
[image-gallery3]:./asset/gallery/20240622_04h57m00s_@hervyqa.png
[image-gallery4]:./asset/gallery/20240622_05h20m33s_@hervyqa.png

[profile]:./user/profile/profile_1.nix
[abbr.nix]:./user/abbr.nix
[processor.nix]:./nixos/hardware/processor.nix
[partition.nix]:./nixos/hardware/partition.nix
[swapdevices.nix]:./nixos/hardware/swapdevices.nix
[MIT License]:./LICENSE.md

