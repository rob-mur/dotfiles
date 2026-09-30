# phone — Android Terminal (Debian/AVF) host

Home Manager + system-manager config for the Android **Linux Terminal** VM
(Debian, aarch64). `home-manager switch` applies both halves in one step.

## Bootstrap a fresh / reset VM

On a freshly reset VM, as the `droid` user (default password: `droid`):

```sh
curl -fsSL https://raw.githubusercontent.com/rob-mur/dotfiles/main/hosts/phone/wizard.sh -o ~/wizard.sh
bash ~/wizard.sh
```

The wizard: installs apt deps → sets up SSH keys (paste or generate) → clones
this repo to `~/repos/dotfiles` → installs Nix → runs the home-manager +
system-manager switch → sets up `gh` auth.

**It is resumable.** Android kills the terminal (and often the whole VM) when
backgrounded, so a long step can die mid-run. Just run `bash ~/wizard.sh`
again — every step checkpoints to `~/.local/state/phone-wizard/`, so finished
steps are skipped and an interrupted Nix build resumes from the on-disk store
cache. The wizard also relaunches itself inside a tmux session, so a shell
disconnect with the VM still alive is survivable:

```sh
tmux attach -t phone-wizard
```

Start over from scratch with `rm -rf ~/.local/state/phone-wizard`.

Rebuild after config changes with the `snrs` alias (runs
`home-manager switch --flake .#dev` from this directory).

## The shadow-lockout fix (`droid-login.nix`)

This host used to intermittently lock itself out — `sudo`, `su`, `passwd`, and
login all failing with *"account validation failure, is your account locked?"* —
after which the only recovery was wiping the VM.

**Cause:** `sshd.nix` declares `users.users.sshd`, which turns on
system-manager's **userborn**. userborn regenerates `/etc/passwd` + `/etc/shadow`
on every boot, making it and Debian/cloud-init (which owns the `droid` user)
two owners of `/etc/shadow`. On a hard VM kill (closing the app mid-write) ext4
leaves the freshly rewritten shadow truncated, the `droid` line vanishes, and
cloud-init won't re-add it on the same instance-id — a permanent lockout.

**Fix:** `droid-login.nix` adds a system-manager oneshot
(`droid-login-heal.service`) ordered `After=userborn.service` and
`Before=sysinit.target`, so it runs on every boot before anything you could log
in with. If `droid`'s shadow entry is intact it snapshots it; if it's missing or
truncated it splices a good line back in — from that snapshot, then Debian's
`/etc/shadow-` backup, then a baked fallback (password: `droid`). A truncated
shadow now self-repairs at boot instead of locking the VM out.
