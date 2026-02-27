# Testing Patterns

**Analysis Date:** 2026-02-27

## Test Framework

**Runner:**
- Not detected - no test framework configuration found

**Assertion Library:**
- Not applicable

**Run Commands:**
```bash
# No test commands available
# This is a NixOS configuration repository
```

## Test File Organization

**Location:**
- No test files found (no `*.test.*` or `*.spec.*` files)

**Naming:**
- Not applicable

**Structure:**
- Not applicable

## Test Structure

**Suite Organization:**
This is a NixOS dotfiles repository. Testing is performed differently than traditional software:

**NixOS Configuration Testing:**
```bash
# Dry-run build to check for errors
nixos-rebuild dry-build

# Build without activating
nixos-rebuild build

# Full rebuild with activation
nixos-rebuild switch
```

**Neovim Configuration Testing:**
```vim
" Health checks for installed plugins
:checkhealth

" Check specific plugin health
:checkhealth telescope
:checkhealth lsp
```

**Patterns:**
- Declarative validation at build time
- Type checking via Nix's evaluation system
- Runtime validation via NixOS activation

## Mocking

**Framework:** Not applicable

**Patterns:**
- NixOS uses `mkDefault` and `mkOverride` for configuration layering
- Neovim plugins tested via actual usage
- No traditional mocking framework

**What to Mock:**
- Not applicable for configuration management

**What NOT to Mock:**
- System services and hardware detection rely on real system state

## Fixtures and Factories

**Test Data:**
Configuration values are defined in option files:

```nix
# options.nix defines default values
machineType = lib.mkOption {
  type = lib.types.enum ["desktop" "laptop_perso" "work-laptop"];
  default = "desktop";
  description = "Machine profile to use";
};
```

**Location:**
- Configuration defaults: `options.nix`
- Machine-specific configs: `hosts/*/` directories
- Profile configurations: `user/profile/profiles/`

## Coverage

**Requirements:** Not applicable

**View Coverage:**
- NixOS evaluation errors indicate configuration problems
- Successful `nixos-rebuild switch` indicates valid configuration

## Test Types

**Unit Tests:**
- Not applicable in traditional sense
- Each Nix module is independently evaluable
- `nix-instantiate --eval` can validate individual modules

**Integration Tests:**
- Full system rebuild validates integration
- `nixos-rebuild dry-build` tests without activation

**E2E Tests:**
- Not used

## Common Patterns

**Configuration Validation:**
```bash
# Check syntax and evaluation
nix-instantiate --eval /etc/nixos/configuration.nix

# Dry-run to catch build issues
nixos-rebuild dry-build

# Build without switching
nixos-rebuild build

# Full activation
nixos-rebuild switch
```

**Rollback Pattern:**
```bash
# NixOS keeps previous generations
nixos-rebuild switch --rollback

# List available generations
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

**Neovim Plugin Validation:**
```vim
" Check plugin status
:Lazy

" Verify LSP servers
:LspInfo

" Verify Mason installations
:Mason

" Check formatting
:ConformInfo
```

## Testing Philosophy

This repository uses **declarative testing**:

1. **Build-time validation:** Invalid Nix syntax fails during evaluation
2. **Type safety:** Nix type system catches misconfigurations
3. **Activation testing:** System activation reveals runtime issues
4. **Rollback safety:** Previous generations preserved automatically

**Testing workflow:**
```bash
# 1. Edit configuration
vim nixos/system/boot.nix

# 2. Validate syntax
nix-instantiate --eval

# 3. Test build
nixos-rebuild build

# 4. Review diff
nix store diff-closures /nix/var/nix/profiles/system{,-*-link}

# 5. Activate
nixos-rebuild switch

# 6. Rollback if needed
nixos-rebuild switch --rollback
```

## Configuration-Specific Testing

**Home-Manager:**
```bash
# Standalone Home-Manager testing
home-manager build

# Activate Home-Manager changes
home-manager switch
```

**Flake-based Testing:**
```bash
# Check flake
nix flake check

# Show flake outputs
nix flake show

# Build specific host
nix build .#nixosConfigurations.hostname.config.system.build.toplevel
```

## Health Check Locations

**System Health:**
- `/var/log/nixos-rebuild.log` - Build logs
- `journalctl -xe` - System service status
- `systemctl status` - Service health

**Neovim Health:**
- `:checkhealth` output identifies missing dependencies
- `:Mason` shows LSP/formatter installation status
- `:Lazy` shows plugin load status

---

*Testing analysis: 2026-02-27*
