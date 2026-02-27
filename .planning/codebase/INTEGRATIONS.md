# External Integrations

**Analysis Date:** 2026-02-27

## APIs & External Services

**AI Assistants:**
- Claude Code - AI coding assistant from Anthropic
  - SDK/Client: claude-code package from nixpkgs
  - Package.json: `.claude/package.json` (CommonJS)
  - Hooks: GSD integration hooks in `.claude/hooks/`

- Gemini CLI - Google's Gemini AI CLI tool
  - SDK/Client: gemini-cli-bin package from nixpkgs
  - Package.json: `.gemini/package.json` (CommonJS)
  - Hooks: GSD integration hooks in `.gemini/hooks/`

- OpenCode - Additional AI coding tool
  - Package.json: `.opencode/package.json` (CommonJS)
  - Hooks: GSD integration hooks in `.opencode/hooks/`

**Version Control Hosting:**
- GitHub - Primary git hosting
  - Integration: Git URL rewriting in `home/programs/git.nix`
  - URL pattern: `git@github.com:` for HTTPS URLs
  - CLI: `gh` (GitHub CLI) configured in `home/programs/gh.nix`

- GitLab - Git hosting alternative
  - Integration: Git URL rewriting in `home/programs/git.nix`
  - URL pattern: `git@gitlab.com:` for HTTPS URLs

- SourceHut - Git hosting (preferred for this repo)
  - Integration: Git URL rewriting in `home/programs/git.nix`
  - URL pattern: `git@git.sr.ht:` for HTTPS URLs

**Nix Ecosystem:**
- nixpkgs (github:nixos/nixpkgs) - Package repository
- nixGL (github:nix-community/nixGL) - OpenGL wrapper for non-NixOS
- devenv (github:cachix/devenv) - Development environments
- git-hooks.nix (github:cachix/git-hooks) - Pre-commit hooks

**VPN:**
- Tailscale - Mesh VPN service
  - Service: `nixos/services/tailscale.nix`
  - Status: Enabled with routing features
  - Integration: System-level service

- ProtonVPN - VPN service
  - Client: GUI application
  - Config: `home/programs/protonvpn-gui.nix`

## Data Storage

**Databases:**
- PostgreSQL
  - Connection: System service configuration
  - Client: Native PostgreSQL client from nixpkgs
  - Status: Configured but disabled by default
  - Config file: `nixos/services/postgresql.nix`
  - Settings: TCP/IP enabled, SSL disabled

- MySQL/MariaDB
  - Connection: System service configuration
  - Client: MariaDB package
  - Status: Configured but disabled by default
  - Config file: `nixos/services/mysql.nix`

- MongoDB
  - Connection: System service configuration
  - Client: Native MongoDB client from nixpkgs
  - Status: Configured but disabled by default
  - Config file: `nixos/services/mongodb.nix`

- Redis
  - Connection: System service configuration per hostname
  - Client: Native Redis client from nixpkgs
  - Status: Configured but disabled by default
  - Config file: `nixos/services/redis.nix`
  - Port: 6379

- SQLite
  - Client: sqlitebrowser GUI tool
  - Config: `home/packages/desktop/database.nix`
  - Usage: Local database browsing

**File Storage:**
- Local filesystem only
- Git LFS enabled for large file storage
- Docker volumes for containerized storage

**Caching:**
- Redis available but disabled by default
- Nix binary cache via Cachix

## Authentication & Identity

**Auth Provider:**
- Custom per-application
  - Git: SSH keys for git hosting services
  - Password Store: `pass` with rofi integration
  - KeePassXC: Password manager (`home/programs/keepassxc.nix`)
  - Proton Authenticator: TOTP authentication (`home/programs/proton-auth.nix`)

**SSH:**
- SSH configuration managed via Home Manager
- Config: `home/programs/ssh.nix`
- Keys for GitHub, GitLab, SourceHut

## Monitoring & Observability

**Error Tracking:**
- None (dotfiles repository)

**Logs:**
- systemd journal for system services
- Application logs managed per-application

**System Monitoring:**
- bottom - Process/system monitor (TUI)
- htop - Alternative system monitor
- btop - Alternative system monitor

## CI/CD & Deployment

**Hosting:**
- Self-hosted NixOS systems
- Local development environments via devenv

**CI Pipeline:**
- None detected (personal dotfiles repository)

**Build System:**
- Nix flakes for reproducible builds
- nixos-rebuild for system deployment
- home-manager for user environment deployment

## Environment Configuration

**Required env vars:**
- DIRENV_WARN_TIMEOUT - Direnv warning timeout (20s)
- GOBIN - Go binary location (.go/bin)
- GOPATH - Go workspace (.go)

**Secrets location:**
- Environment managed through Nix configuration
- `.envrc` present but does not contain secrets
- Git configured to skip HTTPS credentials via SSH URL rewriting

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None

## Additional Services

**DNS:**
- AdGuard Home - DNS ad blocking and filtering
  - Config: `nixos/services/adguardhome.nix`
  - Status: Configured but disabled
  - Firewall: Auto-open when enabled

- DNSCrypt - DNS encryption
  - Config: `nixos/services/dnscrypt.nix`

**Analytics:**
- Metabase - Business intelligence platform
  - Config: `nixos/services/metabase.nix`
  - Status: Configured but disabled

**AI/ML:**
- Ollama - Local LLM inference server
  - Config: `nixos/services/ollama.nix`
  - Status: Configured but disabled

**Container Platform:**
- Docker - Container runtime
  - Config: `nixos/virtual/docker.nix`
  - Status: Enabled with auto-prune
  - Boot: Enabled on boot

**Media/Communication:**
- Discord - Chat platform (`home/programs/discord.nix`)
- Signal - Encrypted messaging (`home/programs/signal.nix`)
- Slack - Team communication (`home/programs/slack.nix`)
- Spotify - Music streaming (`home/programs/spotify.nix`)
- MPD - Music Player Daemon with ncmpcpp client

**Development Services:**
- RStudio Server - R development environment
  - Config: `nixos/services/rstudio-server.nix`

- FTP Server - vsftpd
  - Config: `nixos/services/vsftpd.nix`

**Time Sync:**
- systemd-timesyncd - Network time synchronization
  - Config: `nixos/services/timesyncd.nix`

---

*Integration audit: 2026-02-27*
