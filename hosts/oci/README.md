# oci — command-and-control box on Oracle Cloud Always Free

A headless NixOS machine on an Ampere A1 VM: the `home/minimal.nix` CLI
setup plus the tools for driving the other hosts (nixos-anywhere,
deploy-rs, sops/age, gh, devenv, docker, claude-code). You reach it over
Tailscale, with mosh for phone sessions. Public SSH stays open as a fallback.

## What the free tier allows, and how this box uses it

| Always Free allowance            | Used here                             |
| -------------------------------- | ------------------------------------- |
| A1 Arm: 4 OCPU, 24 GB RAM total  | one `VM.Standard.A1.Flex`, 4 OCPU / 24 GB |
| Block storage: 200 GB total      | one 200 GB boot volume                |
| Egress: 10 TB/month              | —                                     |

The two AMD `E2.1.Micro` VMs are also free, but each one needs a boot volume
of at least ~47 GB, which comes out of the same 200 GB. Put all 200 GB on
this box unless you actually want the micros.

Check <https://www.oracle.com/cloud/free/> before you create anything.
Oracle has changed these numbers in the past.

## 1. Account setup (one-off)

1. **Pick the home region carefully.** You can't change it later, and the
   Always Free A1 allowance only applies there. Pick a region near you that
   isn't famous for "Out of host capacity" errors. Frankfurt and Amsterdam
   are often full; Paris, Marseille, Milan and Stockholm are usually easier.
2. **Upgrade to Pay As You Go** (Billing → Upgrade and Manage Payment).
   Always Free resources stay free. You get two things:
   - A1 capacity is much easier to get.
   - Oracle stops reclaiming "idle" Always Free instances. A C&C box that
     sits at under 20% CPU/network/memory for 7 days would qualify.
3. Straight after upgrading, add a **budget alert**: Billing → Budgets,
   monthly budget of 1 in your currency, alert at 100% actual spend.
   Any charge then means something you created left the free tier.

## 2. Network

Networking → Virtual Cloud Networks → **Start VCN Wizard** → "Create VCN
with Internet Connectivity". The defaults are fine. This gives you a public
subnet, an internet gateway, and a security list that allows ingress on
TCP 22.

Edit the public subnet's **Default Security List** → Add Ingress Rule:

- Source `0.0.0.0/0`, protocol UDP, destination port `41641`. This lets
  Tailscale make direct connections instead of relaying through DERP. It's
  optional but noticeably snappier.

Don't open anything else. Everything other than SSH is reached over the
tailnet, which the NixOS firewall trusts completely (`trustedInterfaces`).

## 3. Create the instance

Compute → Instances → Create instance:

- **Image:** Canonical Ubuntu (latest LTS, aarch64). It only exists long
  enough for nixos-anywhere to kexec out of it.
- **Shape:** Ampere → `VM.Standard.A1.Flex`, **4 OCPU, 24 GB**.
- **Networking:** the VCN/public subnet from step 2, with "Assign a public
  IPv4 address" ticked.
- **SSH keys:** paste the public key listed in `oci.nix`
  (`users.users.<name>.openssh.authorizedKeys.keys`). Add your key there
  first if you'll install from a different machine.
- **Boot volume:** tick "Specify a custom boot volume size", set **200 GB**.
  Leave "Use in-transit encryption" at its default.

If you get "Out of host capacity", try another availability domain. If that
fails too, retry later. PAYG (step 1) usually makes this go away.

Once it's running, check you can reach it: `ssh ubuntu@<public-ip>`.

## 4. Install NixOS

nixos-anywhere kexecs the Ubuntu box into a NixOS installer, partitions
`/dev/sda` with `disk-config.nix`, and installs this flake. The Ubuntu user
has passwordless sudo, so it doesn't need root SSH.

The system is aarch64, so build it on the target: it has 4 cores and 24 GB
of RAM. This way you don't need a binfmt emulator locally, and it works the
same from the x86 desktop, the laptops, or the phone.

```sh
cd hosts/oci
nix run github:nix-community/nixos-anywhere -- \
  --flake .#dev \
  --build-on remote \
  --target-host ubuntu@<public-ip>
```

The box reboots into NixOS when it's done. Check you can reach it:
`ssh rob@<public-ip>`. Your host key will have changed; remove the old one
with `ssh-keygen -R <public-ip>`.

## 5. First boot

```sh
sudo tailscale up --ssh      # prints a login URL
```

Then in the Tailscale admin console, turn off **key expiry** for this
machine. From here on, use `ssh rob@oci` or `mosh rob@oci` over the tailnet.

On the box:

```sh
ssh-keygen -t ed25519        # add ~/.ssh/id_ed25519.pub to GitHub / Forgejo
gh auth login
mkdir -p ~/repos && git clone git@github.com:rob-mur/dotfiles ~/repos/dotfiles
```

After that, `snrs` rebuilds the box from `~/repos/dotfiles/hosts/oci`, the
same as on every other NixOS host.

### Optional: close public SSH

When Tailscale SSH has been reliable for a while, you can delete the TCP 22
ingress rule from the security list. The break-glass path is then OCI's
serial console (instance page → Resources → Console connection). The kernel
already logs to `ttyAMA0` for this. There's no password to log in with,
though, so set one with `sudo passwd rob` first if you want that path to
be usable.

## Recovery

- **Won't boot after a rebuild:** open the serial console and pick an
  older generation from the GRUB menu.
- **Completely broken:** terminate the instance and redo steps 3–4.
  Nothing on this box should be precious; keep it all in git.
