# Architecture

**Analysis Date:** 2026-02-27

## Pattern Overview

**Overall:** Modular NixOS Configuration with Home Manager Integration

**Key Characteristics:**
- Declarative system and user configuration using Nix expression language
- Flake-based architecture with pinned dependencies for reproducibility
- Layered separation between system-level (NixOS) and user-level (Home Manager) concerns
- Machine-specific profiles override base configuration through Nix module system
- All configuration modules composable via imports, enabling selective feature activation

## Layers

**Root Configuration Layer:**
- Purpose: Top-level orchestration and shared option definitions
- Location: `/home/rob/repos/dotfiles/`
- Contains: Entry point (`configuration.nix`), global options (`options.nix`), flake manifests
- Depends on: NixOS modules, Home Manager modules, user profiles
- Used by: Host-specific configurations via import

**Host-Specific Layer:**
- Purpose: Machine-specific configuration and hardware details
- Location: `/home/rob/repos/dotfiles/hosts/{laptop_perso,desktop,work-laptop}/`
- Contains: Flake definitions, hardware configuration, machine type selection
- Depends on: Root configuration layer
- Used by: NixOS rebuild commands targeting specific hosts

**NixOS System Layer:**
- Purpose: Operating system configuration and system-wide programs/services
- Location: `/home/rob/repos/dotfiles/nixos/`
- Contains: System settings, hardware drivers, system services, global programs
- Depends on: Hardware detection, NixOS module system
- Used by: System initialization and rebuild

**Home Manager Layer:**
- Purpose: User-level configuration, dotfiles, and per-user services
- Location: `/home/rob/repos/dotfiles/home/`
- Contains: User programs, services, themes, window manager configuration
- Depends on: NixOS layer for integration (`nixos.nix`) or standalone mode (`standalone.nix`)
- Used by: User session initialization

**User Profile Layer:**
- Purpose: User-specific variables and profile selection
- Location: `/home/rob/repos/dotfiles/user/`
- Contains: Profile definitions, shell abbreviations, color schemes, themes
- Depends on: Nothing (pure data definitions)
- Used by: Both NixOS and Home Manager layers

**Module Categories (within layers):**
- Hardware: `/home/rob/repos/dotfiles/nixos/hardware/` - Processor, graphics, peripherals
- Programs: `/home/rob/repos/dotfiles/nixos/programs/`, `/home/rob/repos/dotfiles/home/programs/` - Application configuration
- Services: `/home/rob/repos/dotfiles/nixos/services/`, `/home/rob/repos/dotfiles/home/services/` - Daemons and background services
- System: `/home/rob/repos/dotfiles/nixos/system/` - Core system settings
- Themes: `/home/rob/repos/dotfiles/nixos/themes/`, `/home/rob/repos/dotfiles/home/themes/` - Visual styling
- Config: `/home/rob/repos/dotfiles/home/config/` - User configuration directories

## Data Flow

**System Build Flow:**

1. User invokes `sudo nixos-rebuild switch --flake .#dev` from host directory
2. Nix evaluates host flake (`hosts/{machine}/flake.nix`)
3. Flake imports root configuration (`configuration.nix`)
4. Root imports options, NixOS layer, and Home Manager integration
5. NixOS modules aggregate from `/home/rob/repos/dotfiles/nixos/` via `default.nix` imports
6. Home Manager modules loaded via `/home/rob/repos/dotfiles/home/nixos.nix` wrapper
7. User profile variables from `/home/rob/repos/dotfiles/user/profile/` inject into configuration
8. Nix builds derivations for system and user environments
9. System activation switches symlinks and restarts changed services

**Configuration Resolution:**

1. Host-specific settings (from `hosts/{machine}/*.nix`) set machine type, hostname, user
2. Global options (`options.nix`) provide defaults with `mkOption` and `lib.mkDefault`
3. Machine-specific overrides take precedence via Nix module priority system
4. Profile variables (`user/profile/profiles/*.nix`) provide user-specific values
5. All modules imported via `imports = [...]` lists compose into final configuration

**State Management:**
- Nix store (`/nix/store/`) contains immutable package builds
- System generations tracked in `/nix/var/nix/profiles/system`
- Home Manager generations in `/home/${user}/.local/state/nix/profiles/home-manager`
- User state version pinned via `config.version` option
- Rollback achieved by switching to previous generation

## Key Abstractions

**Machine Profiles:**
- Purpose: Define machine-specific behavior via type selection
- Examples: `machineType = "desktop"`, `machineType = "laptop_perso"`, `machineType = "work-laptop"`
- Pattern: Enum option in `options.nix` referenced throughout modules for conditional configuration

**Module Composition:**
- Purpose: Break configuration into single-responsibility units
- Examples: `nixos/services/greetd.nix`, `home/programs/firefox.nix`, `nixos/hardware/graphics.nix`
- Pattern: Each `.nix` file exports function `{ config, pkgs, ... }: { ... }` with settings, imported via `default.nix` aggregators

**Home Manager Integration Modes:**
- Purpose: Support both NixOS-integrated and standalone Home Manager
- Examples: `/home/rob/repos/dotfiles/home/nixos.nix` (integrated), `/home/rob/repos/dotfiles/home/standalone.nix` (standalone)
- Pattern: Wrapper files adapt same module imports to different contexts

**Option Definitions:**
- Purpose: Centralize configurable variables with types and defaults
- Examples: `name`, `email`, `hostname`, `timezone`, `version` in `options.nix`
- Pattern: `lib.mkOption` with type, default, description; consumed via `config.{option}`

**User Abbreviations:**
- Purpose: Shell command aliases defined declaratively
- Examples: `/home/rob/repos/dotfiles/user/abbr/default.nix`
- Pattern: Attrset of abbreviations imported into `home.shellAliases`

## Entry Points

**Host Flake:**
- Location: `/home/rob/repos/dotfiles/hosts/{machine}/flake.nix`
- Triggers: `nixos-rebuild` command with `--flake` flag
- Responsibilities: Pin nixpkgs version, load Home Manager, import machine configuration, define outputs

**Root Configuration:**
- Location: `/home/rob/repos/dotfiles/configuration.nix`
- Triggers: Imported by host-specific configuration
- Responsibilities: Import global options, aggregate NixOS modules, import Home Manager integration

**Host Configuration:**
- Location: `/home/rob/repos/dotfiles/hosts/{machine}/{machine}.nix`
- Triggers: Imported by host flake
- Responsibilities: Set machine type, define hardware (filesystems, boot), import root configuration

**NixOS Module Aggregator:**
- Location: `/home/rob/repos/dotfiles/nixos/default.nix`
- Triggers: Imported by root configuration
- Responsibilities: Import all system-level module categories (hardware, programs, services, system, themes, virtual)

**Home Manager Entry:**
- Location: `/home/rob/repos/dotfiles/home/nixos.nix`
- Triggers: Imported by root configuration
- Responsibilities: Configure Home Manager module, import user-level modules, set session variables

## Error Handling

**Strategy:** Build-time validation via Nix type system and assertion checks

**Patterns:**
- Type checking: `lib.types.enum`, `lib.types.str`, `lib.types.bool` enforce valid option values
- Assertions: Nix assertions in modules validate configuration coherence
- Dry-run builds: `nixos-rebuild dry-build` previews changes without activation
- Generation rollback: Boot menu allows selecting previous system generations
- Module isolation: Failures in optional modules don't prevent core system build

## Cross-Cutting Concerns

**Logging:**
- System logs via systemd journal (`journalctl`)
- Build logs in `/tmp/nix-build-*` during evaluation
- NixOS rebuild output shows activation script execution

**Validation:**
- Nix type system validates option types at build time
- Module assertions check configuration consistency
- Flake lock ensures dependency reproducibility

**Authentication:**
- User configuration via `/home/rob/repos/dotfiles/nixos/system/users.nix`
- Home Manager manages user-level credentials (GPG, SSH via `gnupg.nix`, `ssh.nix`)
- System services handle authentication (PAM, polkit through NixOS modules)

**Session Management:**
- Environment variables set in `/home/rob/repos/dotfiles/home/nixos.nix` (Wayland, Qt, GTK)
- Display manager via `/home/rob/repos/dotfiles/nixos/services/greetd.nix`
- Window manager (Sway) configured in `/home/rob/repos/dotfiles/home/wayland/`

**State Versioning:**
- `config.version` option pins state version for compatibility
- Same version used for `system.stateVersion` and `home.stateVersion`
- Prevents breaking changes during upgrades

---

*Architecture analysis: 2026-02-27*
