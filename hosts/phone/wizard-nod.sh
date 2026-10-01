#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# phone wizard (nix-on-droid): fresh nix-on-droid app  ->  working dotfiles.
#
# The nix-on-droid counterpart of wizard.sh (Debian/AVF VM). A fresh app has
# Nix but no curl, so bootstrap with:
#
#     nix --extra-experimental-features 'nix-command flakes' run nixpkgs#curl -- \
#       -fsSL https://raw.githubusercontent.com/rob-mur/dotfiles/main/hosts/phone/wizard-nod.sh -o ~/wizard.sh
#     bash ~/wizard.sh
#
# RESUMABLE. Android kills the app when backgrounded, so long steps can die
# mid-run. Just run the SAME command again — every step checkpoints to
# ~/.local/state/phone-wizard/, so finished steps are skipped instantly and an
# interrupted Nix build resumes from the on-disk store cache.
# ---------------------------------------------------------------------------
set -euo pipefail

REPO="https://github.com/rob-mur/dotfiles.git"
BRANCH="${DOTFILES_BRANCH:-main}"
DEST="$HOME/repos/dotfiles"
HOSTDIR="$DEST/hosts/phone"
RAW_URL="https://raw.githubusercontent.com/rob-mur/dotfiles/$BRANCH/hosts/phone/wizard-nod.sh"
NIXFLAGS=(--extra-experimental-features 'nix-command flakes')

STATE="$HOME/.local/state/phone-wizard"
SELF="$STATE/wizard.sh"
mkdir -p "$STATE"

# --- ui helpers (prompts read the real terminal so pipes still work) -------
ask()  { local q="$1" d="${2:-}" a; printf '%s%s: ' "$q" "${d:+ [$d]}" >&2; read -r a < /dev/tty 2>/dev/null || a=""; printf '%s' "${a:-$d}"; }
yesno(){ local a; a=$(ask "$1 (y/N)"); case "$a" in [yY]*) return 0;; *) return 1;; esac; }
say()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*" >&2; }
warn() { printf '\033[1;33m!!  %s\033[0m\n' "$*" >&2; }

# --- checkpointing: each step runs once, marked done on success ------------
is_done(){ [ -f "$STATE/done.$1" ]; }
mark(){ : > "$STATE/done.$1"; }
step(){ local n="$1"; shift; if is_done "$n"; then printf '   \033[2m[skip] %s\033[0m\n' "$n" >&2; return 0; fi; say "$n"; "$@"; mark "$n"; }

# keep a persistent copy of this script for resume / re-exec
persist_self(){
  local src="${BASH_SOURCE[0]:-}"
  if [ -n "$src" ] && [ -f "$src" ] && [ "$(readlink -f "$src" 2>/dev/null)" != "$(readlink -f "$SELF" 2>/dev/null)" ]; then
    cp "$src" "$SELF"
  elif [ ! -f "$SELF" ]; then
    nix "${NIXFLAGS[@]}" run nixpkgs#curl -- -fsSL "$RAW_URL" -o "$SELF"
  fi
  chmod +x "$SELF" 2>/dev/null || true
}

# A fresh app has only bash, coreutils and nix: no git/curl/ssh/gh, and not
# even grep/awk/sed. Rather than installing them into a profile (which the
# first switch would then fight over), re-run inside a throwaway nix shell
# that provides everything the steps below call. After the switch the same
# tools come from nix-on-droid.nix's environment.packages.
NEEDED=(git curl gh ssh ssh-keygen ssh-keyscan grep awk sed find)
ensure_tools(){
  local missing=() c
  for c in "${NEEDED[@]}"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
  [ "${#missing[@]}" -eq 0 ] && return 0
  [ "${WIZARD_IN_NIX_SHELL:-}" = 1 ] && { warn "still missing inside nix shell: ${missing[*]}"; exit 1; }
  say "Missing ${missing[*]}; re-running inside a nix shell that provides them"
  WIZARD_IN_NIX_SHELL=1 exec nix "${NIXFLAGS[@]}" shell \
    nixpkgs#git nixpkgs#curl nixpkgs#gh nixpkgs#openssh \
    nixpkgs#gnugrep nixpkgs#gawk nixpkgs#gnused nixpkgs#findutils \
    --command bash "$SELF"
}

# =====================  STEP IMPLEMENTATIONS  ==============================

do_nixconf(){
  # Until the first switch manages /etc/nix/nix.conf, enable flakes (and keep
  # builds to one job so the phone doesn't OOM) via the user config.
  local conf="$HOME/.config/nix/nix.conf"
  mkdir -p "$(dirname "$conf")"
  touch "$conf"
  grep -q '^experimental-features' "$conf" || echo 'experimental-features = nix-command flakes' >> "$conf"
  grep -q '^max-jobs' "$conf" || echo 'max-jobs = 1' >> "$conf"
}

do_ssh(){
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  local key="$HOME/.ssh/id_ed25519"
  if [ -f "$key" ]; then
    echo "key already exists at $key"
  elif yesno "Paste an existing private ed25519 key?"; then
    echo "Paste the key, then Ctrl-D on a new line:" >&2
    cat /dev/tty > "$key"; chmod 600 "$key"
    ssh-keygen -y -f "$key" > "$key.pub" 2>/dev/null && echo "derived $key.pub" || warn "could not derive public key (encrypted?)"
  elif yesno "Generate a new ed25519 key instead?"; then
    ssh-keygen -t ed25519 -N "" -f "$key" -C "nix-on-droid@phone"
    echo "Add this public key to GitHub/Forgejo, then press Enter:" >&2
    cat "$key.pub" >&2; ask "Press Enter once added" >/dev/null
  else
    warn "skipping ssh key — ssh remotes (e.g. forgejo) won't work until you add one"
  fi
  touch "$HOME/.ssh/known_hosts" && chmod 600 "$HOME/.ssh/known_hosts"
  for hostspec in "github.com" "-p 2222 forgejo.clarob.uk"; do
    local h="${hostspec##* }"
    grep -q "$h" "$HOME/.ssh/known_hosts" 2>/dev/null || ssh-keyscan $hostspec >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
  done
}

do_clone(){
  mkdir -p "$(dirname "$DEST")"
  if [ -d "$DEST/.git" ]; then
    git -C "$DEST" fetch --all -q && git -C "$DEST" checkout -q "$BRANCH" && git -C "$DEST" pull -q --ff-only || warn "pull skipped (local changes?)"
  else
    git clone -q --branch "$BRANCH" "$REPO" "$DEST"
  fi
}

do_switch(){
  # Nix caches partial work in the store, so a killed-and-rerun switch picks
  # up where it left off.
  nix-on-droid switch --flake "$HOSTDIR#default"
}

do_gh(){
  command -v gh >/dev/null 2>&1 || { warn "gh not found after switch — check nix-on-droid.nix"; return 0; }
  if gh auth status >/dev/null 2>&1; then echo "gh already authenticated"; return 0; fi
  if yesno "Authenticate gh now?"; then
    local tok; tok=$(ask "Paste a GitHub token (blank = interactive login)")
    if [ -n "$tok" ]; then printf '%s' "$tok" | gh auth login --with-token && gh auth setup-git
    else gh auth login && gh auth setup-git; fi
  fi
}

# ===========================  DRIVER  ======================================

persist_self
ensure_tools

step nixconf  do_nixconf
step ssh      do_ssh
step clone    do_clone
step switch   do_switch
step gh       do_gh

say "Done. Restart the app (you should land in zsh). Rebuild later with:  snrs"
echo "   (To start over: rm -rf $STATE)" >&2
