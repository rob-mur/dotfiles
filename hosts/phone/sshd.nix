{pkgs, ...}: let
  port = 2222;
  stateDir = "/var/lib/sshd-direct";
  hostKey = "${stateDir}/ssh_host_ed25519_key";
  sshdConfig = pkgs.writeText "sshd_config" ''
    Port ${toString port}
    HostKey ${hostKey}
    AuthorizedKeysFile .ssh/authorized_keys
    # Password logins for the Android Terminal use case; keys work too.
    PasswordAuthentication yes
    KbdInteractiveAuthentication no
    PermitRootLogin no
    # Without PAM, nixpkgs' sshd falls back to OpenSSH's built-in crypt,
    # which can't verify Debian's yescrypt hashes, so go through PAM (the
    # pam.d/sshd stack below).
    UsePAM yes
    PrintMotd no
    Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
  '';
in {
  # Plain sshd on the VM's own network, so this host is reachable without
  # tailscale (whose built-in SSH keeps working alongside). Port is above
  # 1024 because the Android Terminal app can only forward unprivileged
  # ports from the VM to the phone. system-manager's openssh module expects
  # Debian's sshd, which isn't installed, so this runs nixpkgs' openssh.
  systemd.services.sshd-direct = {
    description = "OpenSSH server (direct, port ${toString port})";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      StateDirectory = "sshd-direct";
      ExecStartPre = pkgs.writeShellScript "sshd-direct-keygen" ''
        [ -f ${hostKey} ] || ${pkgs.openssh}/bin/ssh-keygen -q -t ed25519 -N "" -f ${hostKey}
      '';
      ExecStart = "${pkgs.openssh}/bin/sshd -D -e -f ${sshdConfig}";
      Restart = "always";
    };
  };

  # Debian ships no /etc/pam.d/sshd (openssh-server isn't installed), and
  # nixpkgs' libpam can't load Debian's modules, so a minimal stack using
  # nixpkgs' pam_unix, which checks /etc/shadow (yescrypt included).
  environment.etc."pam.d/sshd".text = let
    pam_unix = "${pkgs.linux-pam}/lib/security/pam_unix.so";
  in ''
    auth     required ${pam_unix}
    account  required ${pam_unix}
    password required ${pam_unix} yescrypt
    session  required ${pam_unix}
    # Registers the login with logind like a local one, which is what sets
    # XDG_RUNTIME_DIR (the Android Terminal's login script runs
    # `systemctl --user` and errors without it). Optional so a logind hiccup
    # never blocks SSH.
    session  optional ${pkgs.systemd}/lib/security/pam_systemd.so
  '';
  # nixpkgs' pam_unix never reads /etc/shadow itself; it always asks this
  # helper, at the path NixOS puts it.
  security.wrappers.unix_chkpwd = {
    source = "${pkgs.linux-pam}/bin/unix_chkpwd";
    setuid = true;
    owner = "root";
    group = "root";
  };

  # Privilege separation user and chroot dir nixpkgs' sshd expects.
  users.users.sshd = {
    isSystemUser = true;
    group = "sshd";
    home = "/var/empty";
  };
  users.groups.sshd = {};
  systemd.tmpfiles.rules = ["d /var/empty 0555 root root -"];
}
