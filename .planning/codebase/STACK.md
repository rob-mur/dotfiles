# Technology Stack

**Analysis Date:** 2026-02-27

## Languages

**Primary:**
- Nix - Configuration management language for declarative system configuration

**Secondary:**
- Bash - Shell scripting for direnv integration
- JavaScript - GSD hooks in `.claude/`, `.gemini/`, `.opencode/` directories

## Runtime

**Environment:**
- NixOS 25.11 (stable channel)
- Linux kernel (host system)

**Package Manager:**
- Nix package manager
- Nix flakes for reproducible builds
- Lockfile: `devenv.lock` present

## Frameworks

**Core:**
- NixOS - Declarative Linux distribution
- Home Manager (release-25.11) - User environment management
- devenv - Development environment manager

**Testing:**
- Not detected

**Build/Dev:**
- devenv - Development shell configuration (configured in `devenv.nix`)
- direnv - Automatic environment loading (`.envrc` present)
- Nix flakes - Reproducible build system

## Key Dependencies

**Critical:**
- nixpkgs (nixos-25.11) - Primary package source from NixOS
- home-manager (release-25.11) - Manages user-level packages and configuration
- cachix/devenv - Development environment framework
- cachix/git-hooks.nix - Pre-commit hook integration

**Infrastructure:**
- nixGL - OpenGL support for non-NixOS systems (work-laptop only)
- flake-compat - Backward compatibility for non-flake Nix
- gitignore.nix - Git ignore integration for Nix builds

**Development Tools (from devenv.nix):**
- claude-code - AI coding assistant
- gemini-cli-bin - CLI tool for Gemini
- Node.js + npm - JavaScript runtime (enabled via languages.javascript)

**System Services (configured but disabled by default):**
- Docker - Container runtime (`nixos/virtual/docker.nix`)
- PostgreSQL - SQL database (`nixos/services/postgresql.nix`)
- MySQL/MariaDB - SQL database (`nixos/services/mysql.nix`)
- MongoDB - NoSQL database (`nixos/services/mongodb.nix`)
- Redis - Key-value store (`nixos/services/redis.nix`)
- Ollama - Local LLM inference (`nixos/services/ollama.nix`)
- AdGuard Home - DNS ad blocking (`nixos/services/adguardhome.nix`)
- Metabase - Analytics platform (`nixos/services/metabase.nix`)

**Language Support:**
- Go - Enabled via home-manager (`home/programs/go.nix`)
- Python - pyenv enabled for version management (`home/programs/pyenv.nix`)
- Python3 - Neovim integration with basedpyright LSP
- Java - Configured in home packages (`home/programs/java.nix`)

**Editor/LSP:**
- Neovim - Primary text editor with Node.js and Python3 support
- Helix - Alternative modal editor
- basedpyright - Python LSP server

## Configuration

**Environment:**
- direnv for automatic environment loading
- `.envrc` present with devenv integration
- `devenv.yaml` specifies nixpkgs source and allowUnfree setting
- Environment variables managed through Nix configuration files

**Build:**
- `devenv.nix` - Development environment specification
- `devenv.lock` - Locked dependencies
- `.devenv.flake.nix` - Generated flake configuration
- `configuration.nix` - Main NixOS configuration entry point
- `options.nix` - Custom NixOS module options
- Multiple `flake.nix` files per host in `hosts/` directory

**Host Configurations:**
- `hosts/desktop/flake.nix` - Desktop machine configuration
- `hosts/laptop_perso/flake.nix` - Personal laptop configuration
- `hosts/work-laptop/flake.nix` - Work laptop (Ubuntu) with Home Manager standalone

## Platform Requirements

**Development:**
- Nix package manager (2.28.3+)
- direnv for automatic environment switching
- Git for version control
- 200+ Linux distributions supported via Nix

**Production:**
- NixOS 25.11 or compatible
- x86_64-linux architecture
- Multi-user Nix installation
- Sandboxed builds enabled

**Work Laptop (Non-NixOS):**
- Ubuntu host with Home Manager standalone
- nixGL for OpenGL compatibility layer
- Home Manager release-25.11

---

*Stack analysis: 2026-02-27*
