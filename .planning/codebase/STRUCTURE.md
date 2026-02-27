# Codebase Structure

**Analysis Date:** 2026-02-27

## Directory Layout

```
dotfiles/
├── configuration.nix        # Root entry point
├── options.nix              # Global configuration options
├── hosts/                   # Machine-specific configurations
│   ├── laptop_perso/        # Personal laptop configuration
│   ├── desktop/             # Desktop configuration
│   └── work-laptop/         # Work laptop configuration
├── nixos/                   # System-level NixOS configuration
│   ├── hardware/            # Hardware-specific modules
│   ├── programs/            # System-wide programs
│   ├── services/            # System services
│   ├── system/              # Core system settings
│   ├── themes/              # System-level themes
│   └── virtual/             # Virtualization configuration
├── home/                    # Home Manager (user-level) configuration
│   ├── accounts/            # User account configuration
│   ├── config/              # ~/.config directory contents
│   ├── dconf/               # Dconf settings
│   ├── fonts/               # User font configuration
│   ├── packages/            # User packages without config
│   ├── programs/            # User programs with config
│   ├── services/            # User services
│   ├── shell/               # Shell configuration
│   ├── themes/              # User-level themes
│   ├── wayland/             # Wayland/Sway window manager
│   └── xdg/                 # XDG configuration
├── user/                    # User-specific data and profiles
│   ├── abbr/                # Shell abbreviations/aliases
│   ├── color/               # Color scheme definitions
│   ├── profile/             # User profile variables
│   └── theme/               # Theme variables
├── archive/                 # Deprecated/old configurations
├── .planning/               # Project planning and documentation
├── .gemini/                 # Gemini AI assistant configuration
├── .opencode/               # OpenCode configuration
└── .devenv/                 # Development environment
```

## Directory Purposes

**`/home/rob/repos/dotfiles/` (Root):**
- Purpose: Top-level configuration entry points and metadata
- Contains: Root Nix files, README, license, git configuration
- Key files:
  - `configuration.nix`: Main entry importing all layers
  - `options.nix`: Global configuration option definitions

**`/home/rob/repos/dotfiles/hosts/`:**
- Purpose: Machine-specific configuration and hardware details
- Contains: Flake definitions, hardware configuration, machine overrides
- Key files:
  - `hosts/{machine}/flake.nix`: Nix flake with pinned dependencies
  - `hosts/{machine}/{machine}.nix`: Machine-specific settings

**`/home/rob/repos/dotfiles/nixos/`:**
- Purpose: System-level NixOS configuration modules
- Contains: Operating system settings, system services, hardware drivers
- Key files:
  - `nixos/default.nix`: Aggregates all NixOS module imports

**`/home/rob/repos/dotfiles/nixos/hardware/`:**
- Purpose: Hardware-specific configuration
- Contains: Processor, graphics, keyboard, platform detection
- Key files:
  - `hardware/processor.nix`: CPU microcode updates
  - `hardware/graphics.nix`: GPU drivers
  - `hardware/platform.nix`: Platform-specific settings

**`/home/rob/repos/dotfiles/nixos/programs/`:**
- Purpose: System-wide program configuration
- Contains: Programs requiring system-level setup
- Key files:
  - `programs/git.nix`: System git configuration
  - `programs/gnupg.nix`: GPG agent setup
  - `programs/dconf.nix`: Dconf system integration

**`/home/rob/repos/dotfiles/nixos/services/`:**
- Purpose: System services and daemons
- Contains: Service configurations (databases, servers, system daemons)
- Key files:
  - `services/greetd.nix`: Login manager
  - `services/postgresql.nix`: PostgreSQL database
  - `services/tailscale.nix`: VPN service
  - `services/ollama.nix`: AI model server

**`/home/rob/repos/dotfiles/nixos/system/`:**
- Purpose: Core system settings
- Contains: Users, networking, security, locale, boot configuration
- Key files:
  - `system/users.nix`: User account definition
  - `system/nix.nix`: Nix package manager settings
  - `system/network.nix`: Network configuration
  - `system/security.nix`: Security policies

**`/home/rob/repos/dotfiles/nixos/themes/`:**
- Purpose: System-level theming
- Contains: Qt theme configuration
- Key files:
  - `themes/qt.nix`: Qt5/6 theming

**`/home/rob/repos/dotfiles/nixos/virtual/`:**
- Purpose: Virtualization and containerization
- Contains: libvirt, VirtualBox, Docker configurations
- Key files:
  - `virtual/libvirtd.nix`: KVM/QEMU virtualization

**`/home/rob/repos/dotfiles/home/`:**
- Purpose: User-level configuration via Home Manager
- Contains: User programs, dotfiles, services, themes
- Key files:
  - `home/nixos.nix`: Home Manager integration for NixOS
  - `home/standalone.nix`: Standalone Home Manager configuration

**`/home/rob/repos/dotfiles/home/config/`:**
- Purpose: User configuration directory (~/.config)
- Contains: Application-specific configuration files
- Key files:
  - `config/nvim/`: Neovim configuration
  - `config/zsh/`: Zsh configuration
  - `config/qutebrowser/`: Qutebrowser browser configuration

**`/home/rob/repos/dotfiles/home/programs/`:**
- Purpose: User programs with declarative configuration
- Contains: Program-specific Nix modules (90+ programs)
- Key files:
  - `programs/git.nix`: Git user configuration
  - `programs/zsh.nix`: Zsh shell configuration
  - `programs/firefox.nix`: Firefox browser
  - `programs/vscode.nix`: VS Code editor
  - `programs/kitty.nix`: Kitty terminal

**`/home/rob/repos/dotfiles/home/services/`:**
- Purpose: User-level services and daemons
- Contains: User session services
- Key files:
  - `services/mako.nix`: Notification daemon
  - `services/mpd.nix`: Music player daemon
  - `services/syncthing.nix`: File synchronization
  - `services/swayidle.nix`: Idle management

**`/home/rob/repos/dotfiles/home/wayland/`:**
- Purpose: Wayland compositor (Sway) configuration
- Contains: Sway window manager settings
- Key files:
  - `wayland/sway.nix`: Sway configuration
  - `wayland/swaynag.nix`: Sway notification area

**`/home/rob/repos/dotfiles/home/packages/`:**
- Purpose: User packages without configuration
- Contains: Package lists categorized by purpose
- Key files:
  - `packages/basic/`: Essential user packages
  - `packages/desktop/`: Desktop environment packages
  - `packages/keyboard/`: Keyboard-related packages

**`/home/rob/repos/dotfiles/user/`:**
- Purpose: User-specific variables and data definitions
- Contains: Profile data, shell aliases, color/theme variables
- Key files:
  - `user/profile/default.nix`: Profile selector
  - `user/profile/profiles/desktop.nix`: Desktop profile variables
  - `user/abbr/default.nix`: Shell command abbreviations

## Key File Locations

**Entry Points:**
- `/home/rob/repos/dotfiles/hosts/{machine}/flake.nix`: Flake entry for builds
- `/home/rob/repos/dotfiles/configuration.nix`: Root configuration
- `/home/rob/repos/dotfiles/hosts/{machine}/{machine}.nix`: Machine configuration

**Configuration:**
- `/home/rob/repos/dotfiles/options.nix`: Global options
- `/home/rob/repos/dotfiles/user/profile/profiles/{profile}.nix`: Profile variables
- `/home/rob/repos/dotfiles/.envrc`: Direnv configuration
- `/home/rob/repos/dotfiles/devenv.nix`: Development environment

**Core Logic:**
- `/home/rob/repos/dotfiles/nixos/default.nix`: NixOS module aggregator
- `/home/rob/repos/dotfiles/home/nixos.nix`: Home Manager integration
- `/home/rob/repos/dotfiles/nixos/system/default.nix`: System settings aggregator

**Testing:**
- Not applicable - Nix build system provides validation

## Naming Conventions

**Files:**
- `*.nix`: Nix expression files
- `default.nix`: Module aggregator that imports other modules
- `{feature}.nix`: Feature-specific module (e.g., `firefox.nix`, `git.nix`)
- `{machine}.nix`: Machine-specific configuration (e.g., `laptop_perso.nix`)
- `flake.nix`: Nix flake manifest
- `flake.lock`: Flake dependency lock file

**Directories:**
- Lowercase with hyphens for multi-word names (e.g., `work-laptop`, `laptop_perso`)
- Plural for collections (e.g., `programs`, `services`, `hosts`)
- Singular for single-purpose (e.g., `config`, `wayland`, `shell`)

**Options:**
- camelCase for option names (e.g., `machineType`, `hostDir`, `fullname`)
- Descriptive names matching their purpose (e.g., `timezone`, `locale`, `version`)

**Shell Abbreviations:**
- Short 1-3 character codes for common commands (e.g., `v` for nvim, `t` for btop)
- Prefix patterns: `d` for doas, `g` for git, `u` for user systemctl
- Descriptive multi-char for complex operations (e.g., `snrs` for system rebuild)

## Where to Add New Code

**New System Service:**
- Primary code: `/home/rob/repos/dotfiles/nixos/services/{service-name}.nix`
- Import in: `/home/rob/repos/dotfiles/nixos/services/default.nix`
- Pattern: `{ config, pkgs, ... }: { services.{service} = { ... }; }`

**New User Program:**
- Primary code: `/home/rob/repos/dotfiles/home/programs/{program-name}.nix`
- Import in: `/home/rob/repos/dotfiles/home/programs/default.nix`
- Pattern: `{ config, pkgs, ... }: { programs.{program} = { ... }; }`

**New User Service:**
- Primary code: `/home/rob/repos/dotfiles/home/services/{service-name}.nix`
- Import in: `/home/rob/repos/dotfiles/home/services/default.nix`
- Pattern: `{ config, pkgs, ... }: { services.{service} = { ... }; }`

**New Hardware Module:**
- Primary code: `/home/rob/repos/dotfiles/nixos/hardware/{hardware-type}.nix`
- Import in: `/home/rob/repos/dotfiles/nixos/hardware/default.nix`

**New Machine Profile:**
- Create directory: `/home/rob/repos/dotfiles/hosts/{machine-name}/`
- Primary code: `/home/rob/repos/dotfiles/hosts/{machine-name}/{machine-name}.nix`
- Flake manifest: `/home/rob/repos/dotfiles/hosts/{machine-name}/flake.nix`
- Add machine type to: `/home/rob/repos/dotfiles/options.nix` enum
- Create profile: `/home/rob/repos/dotfiles/user/profile/profiles/{machine-name}.nix`

**New Configuration Option:**
- Define in: `/home/rob/repos/dotfiles/options.nix`
- Pattern: `optionName = lib.mkOption { type = ...; default = ...; description = "..."; };`

**New Shell Abbreviation:**
- Add to: `/home/rob/repos/dotfiles/user/abbr/default.nix`
- Pattern: `abbr = { cmd = "expansion"; };`

**Application Config Files:**
- Create: `/home/rob/repos/dotfiles/home/config/{app-name}/`
- Import in: `/home/rob/repos/dotfiles/home/config/default.nix`

**User Package (no config):**
- Add to: `/home/rob/repos/dotfiles/home/packages/basic/default.nix` or `packages/desktop/default.nix`
- Pattern: List package in `home.packages = with pkgs; [ ... ];`

## Special Directories

**`/home/rob/repos/dotfiles/.devenv/`:**
- Purpose: Development environment state
- Generated: Yes (by devenv)
- Committed: No (in .gitignore)

**`/home/rob/repos/dotfiles/.direnv/`:**
- Purpose: Direnv cache
- Generated: Yes (by direnv)
- Committed: No (in .gitignore)

**`/home/rob/repos/dotfiles/.git/`:**
- Purpose: Git repository metadata
- Generated: Yes (by git)
- Committed: No (git internal)

**`/home/rob/repos/dotfiles/.jj/`:**
- Purpose: Jujutsu VCS repository
- Generated: Yes (by jj)
- Committed: No (in .gitignore)

**`/home/rob/repos/dotfiles/archive/`:**
- Purpose: Old/deprecated configuration for reference
- Generated: No
- Committed: Yes

**`/home/rob/repos/dotfiles/.planning/`:**
- Purpose: Project planning and codebase documentation
- Generated: Yes (by GSD commands)
- Committed: Depends on workflow

**`/home/rob/repos/dotfiles/.gemini/`:**
- Purpose: Gemini AI assistant configuration and workflows
- Generated: No
- Committed: Yes

**`/home/rob/repos/dotfiles/.opencode/`:**
- Purpose: OpenCode assistant configuration
- Generated: No
- Committed: Yes

**`/home/rob/repos/dotfiles/result`:**
- Purpose: Symlink to Nix build output
- Generated: Yes (by nix build)
- Committed: No (symlink to /nix/store)

## Module Import Pattern

All category directories follow this pattern:

1. Each feature gets its own `.nix` file (e.g., `firefox.nix`, `git.nix`)
2. A `default.nix` in the category imports all features:
   ```nix
   {...}: {
     imports = [
       ./feature1.nix
       ./feature2.nix
       ./feature3.nix
     ];
   }
   ```
3. Parent directory imports the category `default.nix`
4. Composition continues up to root `configuration.nix`

This enables modular configuration where any feature can be added/removed by modifying only the `default.nix` import list.

---

*Structure analysis: 2026-02-27*
