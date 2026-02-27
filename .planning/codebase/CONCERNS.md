# Codebase Concerns

**Analysis Date:** 2026-02-27

## Tech Debt

**Google Endpoint Verification Patching:**
- Issue: Complex workaround to bypass Google's endpoint verification with hardcoded device attributes
- Files: `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification/package.nix`, `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification.nix`, `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification/nixos-compat.patch`
- Impact: Hardcoded serial number ("2D7K314"), hostname ("DC-2D7K314"), MAC address ("92:27:4c:97:ff:e1"), and model ("Latitude 7640") in build scripts. Functions patched to return immediately with fake values. This is fragile and may break if Google updates their verification logic or if the hardware changes.
- Fix approach: Consider alternative authentication methods or proper device registration. Current implementation short-circuits detection logic entirely with sed injections.

**Archive Directory with Outdated Configurations:**
- Issue: Old NixOS and home-manager configurations remain in archive directory
- Files: `/home/rob/repos/dotfiles/archive/nixos/configuration.nix`, `/home/rob/repos/dotfiles/archive/nixos/flake.nix`, `/home/rob/repos/dotfiles/archive/home-manager/flake.nix`, `/home/rob/repos/dotfiles/archive/dev-module.nix`
- Impact: Contains references to old nixpkgs version (23.05 via `oldnixpgs`), legacy package (yuzu-mainline), and outdated configurations that could confuse future development
- Fix approach: Either fully remove archive directory or add clear documentation that it's historical only. The `oldnixpgs` overlay for yuzu-mainline is a workaround for a removed package.

**Backup File Committed:**
- Issue: Waybar backup configuration committed to repository
- Files: `/home/rob/repos/dotfiles/home/programs/waybar.nix.backup`
- Impact: Dead code that adds confusion about which configuration is active
- Fix approach: Remove backup file and rely on git history for recovery

**Shell Variable Expansion in Session Variables:**
- Issue: Session variables use shell command substitution that won't work as expected in Nix
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix` (line 61), `/home/rob/repos/dotfiles/hosts/desktop/desktop.nix` (line 44)
- Impact: `GITLAB_API_TOKEN = "$(cat $HOME/.auth/gitlab_token)"` sets literal string, not command output. This creates non-functional environment variable.
- Fix approach: Use proper Nix file reading with `builtins.readFile` or handle token loading in shell initialization instead

**Work-Laptop Hardcoded Paths:**
- Issue: Host configuration contains hardcoded absolute paths specific to work machine
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix` (line 11)
- Impact: `hostDir = "/home/robert.murphy/repos/dotfiles/hosts/work-laptop/"` is hardcoded and won't work if username changes or repo location changes
- Fix approach: Use dynamic path resolution with Nix builtins or make configurable

**Commented-Out Configuration:**
- Issue: Disabled Google Cloud project environment variable
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix` (line 60)
- Impact: `# GOOGLE_CLOUD_PROJECT = "duet-assistant"` suggests uncertainty about whether this is needed
- Fix approach: Either enable with proper value, remove entirely, or document why it's disabled

## Known Bugs

**Unsafe Accounts Configuration:**
- Symptoms: Aerc email client requires unsafe-accounts-conf flag
- Files: `/home/rob/repos/dotfiles/home/programs/aerc.nix` (line 21)
- Trigger: Email account setup uses patterns that aerc considers unsafe
- Workaround: `unsafe-accounts-conf = true` disables safety checks

**Initial Password in Archive:**
- Symptoms: Archived NixOS config contains default password
- Files: `/home/rob/repos/dotfiles/archive/nixos/configuration.nix` (line 135)
- Trigger: User creation with `initialPassword = "password"`
- Workaround: This is in archive, but demonstrates poor security practice that could be replicated

## Security Considerations

**Token Files Not Protected:**
- Risk: Sensitive tokens stored in plaintext files in home directory
- Files: Referenced in `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix`, `/home/rob/repos/dotfiles/hosts/desktop/desktop.nix`
- Current mitigation: Files (`~/.auth/gitlab_token`, `~/.config/gcloud/application_default_credentials.json`) are in user home but not tracked in git
- Recommendations: Use proper secret management (agenix, sops-nix) instead of plaintext files. Current approach provides no encryption at rest.

**Endpoint Verification Bypass:**
- Risk: Spoofing device attributes to bypass enterprise security controls
- Files: `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification/package.nix`
- Current mitigation: None - this is intentional bypass
- Recommendations: Consult with security team about proper device enrollment. Current implementation could violate workplace security policies.

**GOOGLE_APPLICATION_CREDENTIALS in Session Variables:**
- Risk: Credential path exposed in environment variables
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix` (line 62), `/home/rob/repos/dotfiles/hosts/desktop/desktop.nix` (line 45)
- Current mitigation: Path only, not credentials themselves
- Recommendations: Ensure credentials file has proper permissions (600) and is not accidentally committed

## Performance Bottlenecks

**Neovim Configuration Size:**
- Problem: Single large init.lua file
- Files: `/home/rob/repos/dotfiles/home/config/nvim/init.lua` (1133 lines)
- Cause: Kickstart.nvim template kept as monolith
- Improvement path: Split into modular configuration as suggested in TODO comment (line 46). Currently all plugins load through single file.

**Multiple Flakes Per Host:**
- Problem: Each host has separate flake with duplicate inputs
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/flake.nix`, `/home/rob/repos/dotfiles/hosts/desktop/flake.nix`, `/home/rob/repos/dotfiles/hosts/laptop_perso/flake.nix`
- Cause: Host-specific flakes instead of single root flake
- Improvement path: Consolidate to single flake at repository root with host-specific outputs. Current structure requires managing multiple flake.lock files.

## Fragile Areas

**NixGL Overlay for Work Laptop:**
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/overlays.nix`
- Why fragile: Complex wrapper system that patches desktop files and wraps every binary with nixGLIntel. Any changes to package structure could break wrapper logic. Desktop file patching with sed is particularly brittle.
- Safe modification: Test any overlay changes with multiple applications. Desktop file format changes in upstream packages will break sed substitutions (lines 58-59).
- Test coverage: No automated tests for wrapper generation

**System Swaylock Wrapper:**
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/overlays.nix` (lines 100-116)
- Why fragile: Relies on system binary at `/usr/bin/swaylock` for PAM compatibility. If system swaylock is updated or removed, lock screen will fail silently.
- Safe modification: Ensure system swaylock is actually installed before deploying this configuration
- Test coverage: No fallback if system binary missing

**Device State Script Patching:**
- Files: `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification/package.nix` (lines 41-48)
- Why fragile: Uses sed to inject return statements into bash functions. If Google updates script structure, sed patterns will fail or inject in wrong places.
- Safe modification: Review patch after any endpoint-verification updates
- Test coverage: No validation that hardcoded values are accepted by Google

**Kickstart.nvim TODO:**
- Files: `/home/rob/repos/dotfiles/home/config/nvim/init.lua` (line 46)
- Why fragile: Contains explicit TODO from upstream template that was never completed
- Safe modification: This is more documentation debt than fragility, but indicates incomplete customization
- Test coverage: N/A

## Scaling Limits

**Single-User Host Configurations:**
- Current capacity: Each host configuration hardcodes single username
- Limit: Cannot support multi-user setups without duplicating entire host configs
- Scaling path: Parameterize username and user-specific paths. Currently `name = "robert.murphy"` and `name = "rob"` are hardcoded per host.

**Home-Manager Standalone Mode Assumptions:**
- Current capacity: Work laptop uses home-manager standalone (non-NixOS)
- Limit: Stubs for NixOS services (`/home/rob/repos/dotfiles/home/standalone.nix` lines 26-38) are no-ops. Features requiring system integration won't work.
- Scaling path: Some services (dbus, xserver) are stubbed and non-functional in standalone mode

## Dependencies at Risk

**Old Nixpkgs for Yuzu:**
- Risk: Archive references nixpkgs 23.05 for removed package (yuzu-mainline)
- Impact: Package was likely removed due to legal issues
- Migration plan: Remove archive or document that yuzu overlay is historical only

**NixGL Dependency:**
- Risk: Work laptop heavily depends on nixgl for GPU acceleration
- Impact: If nixgl project becomes unmaintained, all GPU-accelerated apps will break on work laptop
- Migration plan: NixGL is actively maintained but is a niche project. Consider whether native NixOS install is feasible.

## Missing Critical Features

**No Secret Management:**
- Problem: Secrets handled via plaintext files (`~/.auth/gitlab_token`)
- Blocks: Cannot safely store secrets in git, cannot deploy to new machines without manual token setup
- Priority: Medium - current workaround functional but not secure

**No Testing Framework:**
- Problem: 295 config files with no automated tests
- Blocks: Cannot verify configurations work before deployment. Home-manager and NixOS builds catch syntax errors but not logic errors.
- Priority: Low - Nix provides some guarantees, but no validation of actual behavior

**No CI/CD:**
- Problem: No automated builds or checks
- Blocks: Breaking changes only detected after manual rebuild
- Priority: Low - single user dotfiles, but CI could catch issues earlier

## Test Coverage Gaps

**Endpoint Verification Patches:**
- What's not tested: Whether hardcoded device attributes are accepted by Google servers
- Files: `/home/rob/repos/dotfiles/nixos/programs/endpoint-verification/package.nix`
- Risk: Silent failure if Google rejects spoofed attributes
- Priority: High - security-critical component

**NixGL Wrappers:**
- What's not tested: Desktop file patching, wrapper script generation, GPU access
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/overlays.nix`
- Risk: Applications fail to launch or lack GPU acceleration
- Priority: Medium - affects work laptop functionality

**Shell Variable Expansion:**
- What's not tested: Whether `$(cat $HOME/.auth/gitlab_token)` actually expands at runtime
- Files: `/home/rob/repos/dotfiles/hosts/work-laptop/work-laptop.nix`, `/home/rob/repos/dotfiles/hosts/desktop/desktop.nix`
- Risk: Environment variables contain literal strings instead of token values
- Priority: High - likely broken as written

**Multi-Host Configuration:**
- What's not tested: Whether configurations work on different machines
- Files: All host configs
- Risk: Hardcoded paths and usernames prevent portability
- Priority: Medium - each host is tested individually but not cross-host

---

*Concerns audit: 2026-02-27*
