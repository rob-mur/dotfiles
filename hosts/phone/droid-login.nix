# Keep the `droid` login alive across userborn's shadow regeneration.
#
# Why this exists:
#   This host is Debian (Android Terminal / AVF VM). The `droid` account is
#   created imperatively by cloud-init. But declaring `users.users.sshd` in
#   sshd.nix turns on system-manager's `userborn`, which rewrites
#   /etc/passwd + /etc/shadow on every boot. That makes TWO owners of
#   /etc/shadow, and when the VM is hard-killed (closing the Android app mid
#   write) ext4 can leave the freshly rewritten /etc/shadow truncated — the
#   `droid` line disappears, PAM's account stage fails, and everything that
#   needs it (sudo, su, passwd, login, ssh) dies with
#   "account validation failure, is your account locked?". cloud-init won't
#   re-add droid on the same instance-id, so the VM is locked out until wiped.
#
# What this does:
#   A oneshot that runs AFTER userborn and BEFORE anything you could log in
#   with (sysinit.target), every boot. If droid's shadow entry is intact it
#   just snapshots it for next time; if it's missing/corrupt it splices a
#   good line back in — from the snapshot, then Debian's /etc/shadow- backup,
#   then a baked fallback (password: "droid"). Net effect: a truncated shadow
#   self-repairs before you ever see the lockout.
{
  pkgs,
  lib,
  ...
}: let
  # Static facts about the Terminal App's droid user (uid 1000, primary group
  # users=100). Used to rebuild /etc/passwd if that ever truncates too.
  passwdLine = "droid:x:1000:100:Default user for Terminal App:/home/droid:/usr/bin/bash";

  # Last-resort shadow line (sha512crypt of "droid"). Only used if neither the
  # live shadow, the saved snapshot, nor /etc/shadow- has a usable droid entry.
  # The everyday path restores droid's real hash, so this is rarely hit.
  fallbackShadow = "droid:$6$droidheal$tmfLp/QKjXOlQM7zXgn6BtzM9zwvWHK..2X86ya8isO5iCrd/uiUhtd2wPLLSb7Yr7TF5iBvd684dUEtRu8.t/:20089:0:99999:7:::";

  heal = pkgs.writeShellScript "droid-login-heal" ''
    set -u
    export PATH=${lib.makeBinPath [pkgs.coreutils pkgs.gnugrep pkgs.gawk]}

    SHADOW=/etc/shadow
    SBAK=/etc/shadow-
    PASSWD=/etc/passwd
    PBAK=/etc/passwd-
    SAVE_DIR=/var/lib/droid-login
    SAVE=$SAVE_DIR/shadow.line
    FALLBACK='${fallbackShadow}'
    PWLINE='${passwdLine}'

    mkdir -p "$SAVE_DIR" && chmod 700 "$SAVE_DIR"

    # Print droid's shadow line only if its hash field looks real ($-prefixed).
    valid_droid() {
      awk -F: 'length($2) > 10 && $2 ~ /^\$/ {print; f=1} END{exit !f}' "$1" 2>/dev/null
    }
    # Atomic same-filesystem replace: write temp in the target dir, then rename.
    replace() { # $1=dest  (content on stdin)
      local d t; d=$(dirname "$1"); t=$(mktemp "$d/.heal.XXXXXX")
      cat > "$t" && chmod 640 "$t" && chown root:shadow "$t" 2>/dev/null || true
      mv -f "$t" "$1"
    }

    # --- /etc/passwd: droid must resolve at all ---
    if ! grep -q '^droid:' "$PASSWD" 2>/dev/null; then
      if grep -q '^droid:' "$PBAK" 2>/dev/null; then
        pl=$(grep '^droid:' "$PBAK")
      else
        pl=$PWLINE
      fi
      { grep -v '^droid:' "$PASSWD" 2>/dev/null || true; printf '%s\n' "$pl"; } \
        | { d=$(dirname "$PASSWD"); t=$(mktemp "$d/.heal.XXXXXX"); cat > "$t"; chmod 644 "$t"; chown root:root "$t" 2>/dev/null || true; mv -f "$t" "$PASSWD"; }
    fi

    # --- /etc/shadow: whole-file corruption first (no root line -> restore) ---
    if ! grep -q '^root:' "$SHADOW" 2>/dev/null && grep -q '^root:' "$SBAK" 2>/dev/null; then
      cp -a "$SBAK" "$SHADOW"
    fi

    # --- /etc/shadow: droid entry ---
    if line=$(valid_droid "$SHADOW"); then
      # Healthy: refresh the snapshot for next time and stop.
      printf '%s\n' "$line" > "$SAVE.tmp" && chmod 600 "$SAVE.tmp" && mv -f "$SAVE.tmp" "$SAVE"
      exit 0
    fi

    # Broken: find the best droid line we can.
    line=""
    if [ -s "$SAVE" ] && grep -q '^droid:' "$SAVE"; then line=$(grep '^droid:' "$SAVE"); fi
    if [ -z "$line" ]; then line=$(valid_droid "$SBAK" || true); fi
    if [ -z "$line" ]; then line=$FALLBACK; fi

    { grep -v '^droid:' "$SHADOW" 2>/dev/null || true; printf '%s\n' "$line"; } | replace "$SHADOW"
    sync
    echo "droid-login-heal: repaired /etc/shadow droid entry" >&2
  '';
in {
  systemd.services.droid-login-heal = {
    description = "Restore the droid login entry after userborn regenerates /etc/shadow";
    after = ["userborn.service"];
    before = ["sysinit.target" "shutdown.target"];
    wantedBy = ["sysinit.target"];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = heal;
    };
  };
}
