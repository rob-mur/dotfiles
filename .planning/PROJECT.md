# Dotfiles: Desktop Suspend/Resume Fix

## What This Is

A bug fix for the desktop host in this NixOS dotfiles repository. Currently, when the desktop resumes from suspend, the displays remain blank/off because swayidle is completely disabled (to avoid lock screen), which removes the display resume handler.

## Core Value

Displays must turn back on when resuming from suspend on the desktop host, without showing a lock screen.

## Requirements

### Validated

- ✓ Desktop host configuration exists at `hosts/desktop/desktop.nix` — existing
- ✓ Swayidle service configuration at `home/services/swayidle.nix` — existing
- ✓ Desktop host currently disables swayidle via `lib.mkForce false` — existing
- ✓ Other hosts use swayidle with lock screen — existing

### Active

- [ ] Desktop host has swayidle enabled with custom configuration
- [ ] Desktop swayidle config includes `after-resume` event handler
- [ ] Desktop swayidle config excludes all lock-related events (`before-sleep`, `lock`, `unlock`)
- [ ] Desktop swayidle config handles timeout behaviors without locking
- [ ] Displays turn on after resume from suspend on desktop

### Out of Scope

- Lock screen functionality on desktop — explicitly excluded, multiple users don't know password
- Changes to other hosts' swayidle configuration — only desktop host affected
- Swaylock package configuration — not needed for desktop
- Auto-suspend/sleep timers — focus is only on resume behavior

## Context

**Current setup:**
- Desktop host at `hosts/desktop/desktop.nix` sets `home-manager.users.rob.services.swayidle.enable = lib.mkForce false` (line 50)
- Base swayidle config at `home/services/swayidle.nix` includes `after-resume` event that runs `swaymsg "output * dpms on"`
- When swayidle is completely disabled, the `after-resume` handler doesn't run
- Result: displays stay off after suspend resume

**Root cause:**
- Disabling swayidle entirely removes both the unwanted lock behavior AND the needed display resume functionality
- Standard solution: Keep swayidle enabled but configure it without lock commands

**Research findings:**
- This is a common issue in Sway/swayidle setups
- The `after-resume` event handler is essential for turning displays back on
- Swayidle can be configured with events and timeouts independently

## Constraints

- **Host-specific**: Changes must only affect desktop host, not work-laptop or other hosts
- **NixOS/home-manager**: Solution must use NixOS/home-manager configuration patterns
- **No lock screen**: Desktop host must not show lock screen under any circumstances
- **Minimal change**: Prefer configuration override over restructuring swayidle module

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Keep swayidle enabled on desktop | Need `after-resume` handler for display restoration | — Pending |
| Override swayidle events/timeouts instead of disabling | Granular control vs all-or-nothing | — Pending |

---
*Last updated: 2026-02-27 after initialization*
