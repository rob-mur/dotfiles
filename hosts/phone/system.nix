{
  lib,
  systemConfig,
  ...
}: let
  profile = "/nix/var/nix/profiles/system-manager-profiles/system-manager";
in {
  # Apply the flake's system-manager config (setuid fusermount3 for omnibin)
  # as part of `home-manager switch`, so this host has a single switch step.
  # It only escalates when the system config actually changed, so a normal
  # switch with no system-side change never prompts for sudo.
  home.activation.systemManager = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ "$(readlink -f ${profile} 2>/dev/null)" != "${systemConfig}" ]; then
      verboseEcho "Applying system-manager config ${systemConfig}"
      if [ "$(id -u)" -eq 0 ]; then sudo=""; else sudo="/usr/bin/sudo"; fi
      if ! { run $sudo ${systemConfig}/bin/register-profile \
          && run $sudo ${systemConfig}/bin/activate; }; then
        warnEcho "system-manager activation failed; rerun it with:"
        warnEcho "  sudo ${systemConfig}/bin/register-profile && sudo ${systemConfig}/bin/activate"
      fi
    fi
  '';
}
