#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# phone wizard: blank Android Terminal (Debian/AVF) VM  ->  working dotfiles.
#
# Run on a freshly reset VM, as the `droid` user (default password: droid):
#
#     curl -fsSL https://raw.githubusercontent.com/rob-mur/dotfiles/main/hosts/phone/wizard.sh -o ~/wizard.sh
#     bash ~/wizard.sh
#
# RESUMABLE. Android kills the terminal (and often the VM) when backgrounded,
# so long steps can die mid-run. Just run the SAME command again — every step
# checkpoints to ~/.local/state/phone-wizard/, so finished steps are skipped
# instantly and an interrupted Nix build resumes from the on-disk store cache.
# It also re-launches itself inside a tmux session ('phone-wizard') so a shell
# disconnect (VM still alive) survives — reattach with:  tmux attach -t phone-wizard
# ---------------------------------------------------------------------------
set -euo pipefail

REPO="https://github.com/rob-mur/dotfiles.git"
BRANCH="${DOTFILES_BRANCH:-main}"
DEST="$HOME/repos/dotfiles"
HOSTDIR="$DEST/hosts/phone"
RAW_URL="https://raw.githubusercontent.com/rob-mur/dotfiles/$BRANCH/hosts/phone/wizard.sh"

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

# keep a persistent copy of this script for resume / tmux relaunch
persist_self(){
  local src="${BASH_SOURCE[0]:-}"
  if [ -n "$src" ] && [ -f "$src" ] && [ "$(readlink -f "$src" 2>/dev/null)" != "$(readlink -f "$SELF" 2>/dev/null)" ]; then
    cp "$src" "$SELF"
  elif [ ! -f "$SELF" ]; then
    curl -fsSL "$RAW_URL" -o "$SELF"
  fi
  chmod +x "$SELF" 2>/dev/null || true
}

# =====================  STEP IMPLEMENTATIONS  ==============================

do_apt(){
  sudo apt-get update -qq
  sudo apt-get install -y -qq git curl xz-utils ca-certificates tmux
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
    ssh-keygen -t ed25519 -N "" -f "$key" -C "droid@phone"
    echo "Add this public key to GitHub/Forgejo, then press Enter:" >&2
    cat "$key.pub" >&2; ask "Press Enter once added" >/dev/null
  else
    warn "skipping ssh key — ssh remotes (e.g. forgejo) won't work until you add one"
  fi
  touch "$HOME/.ssh/known_hosts" && chmod 600 "$HOME/.ssh/known_hosts"
  for hostspec in "github.com" "-p 2222 forgejo.clarob.uk"; do
    local h; h=$(printf '%s' "$hostspec" | awk '{print $NF}')
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

do_nix(){
  if command -v nix >/dev/null 2>&1; then echo "nix already installed"; return 0; fi
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install linux --no-confirm --init systemd
}

load_nix(){
  command -v nix >/dev/null 2>&1 && return 0
  for p in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
           "$HOME/.nix-profile/etc/profile.d/nix.sh" /etc/profile.d/nix.sh; do
    [ -f "$p" ] && . "$p" && break
  done
  command -v nix >/dev/null 2>&1
}

do_switch(){
  load_nix || { warn "nix not on PATH — open a fresh shell and re-run: bash $SELF"; exit 1; }
  cd "$HOSTDIR"
  # home-manager switch also applies system-manager (system.nix activation),
  # which installs the droid-login self-heal. Nix caches partial work in the
  # store, so a killed-and-rerun switch picks up where it left off.
  nix run --extra-experimental-features 'nix-command flakes' .#home-manager -- switch -b bak --flake .#dev
}

do_gh(){
  command -v gh >/dev/null 2>&1 || { warn "gh not found after switch — check the home config"; return 0; }
  if gh auth status >/dev/null 2>&1; then echo "gh already authenticated"; return 0; fi
  if yesno "Authenticate gh now?"; then
    local tok; tok=$(ask "Paste a GitHub token (blank = interactive login)")
    if [ -n "$tok" ]; then printf '%s' "$tok" | gh auth login --with-token && gh auth setup-git
    else gh auth login && gh auth setup-git; fi
  fi
}

verify(){
  if [ -e /etc/systemd/system/droid-login-heal.service ] || systemctl cat droid-login-heal.service >/dev/null 2>&1; then
    echo "droid-login-heal installed — protected against the shadow lockout."
  else
    warn "droid-login-heal NOT found. Re-apply with:  cd $HOSTDIR && snrs"
  fi
}

# ===========================  DRIVER  ======================================

persist_self

# Relaunch inside a reattachable tmux session (after apt has provided tmux),
# so a terminal disconnect with the VM still alive is survivable.
maybe_tmux(){
  [ "${WIZARD_NO_TMUX:-}" = 1 ] && return 0
  [ -n "${TMUX:-}" ] && return 0
  command -v tmux >/dev/null 2>&1 || return 0
  [ -t 0 ] || return 0
  say "Continuing inside tmux 'phone-wizard' (reattach any time: tmux attach -t phone-wizard)"
  exec tmux new-session -A -s phone-wizard "bash '$SELF'"
}

step apt      do_apt
maybe_tmux
step ssh      do_ssh
step clone    do_clone
step nix      do_nix
step switch   do_switch
step gh       do_gh
verify

say "Done. Open a new shell (you should land in zsh). Rebuild later with:  snrs"
echo "   (To start over: rm -rf $STATE)" >&2
