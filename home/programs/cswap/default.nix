# cswap (claude-swap): switch Claude Code between two subscription logins,
# and a timer that does it on the weekly burndown.
#
# Logins are added by hand with `cswap add` (never from here: a login is a
# credential). The timer then keeps the PRIMARY login active while its weekly
# burndown is on or under budget and moves to the SECONDARY once it is over,
# using the status line's own formula (../claude-code/burndown.sh). cswap's
# built-in `cswap auto` switches on a usage threshold and has no burndown
# rule, so it is not used. See ./autoswitch.sh for how the primary is read
# while the secondary is active.
#
# CLAUDE_CODE_OAUTH_TOKEN must never be exported: it outranks every stored
# login, which turns each switch into a silent no-op.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.cswap;
  cswap = import ./package.nix {pkgs = pkgs.pkgs-unstable;};
  autoswitch = import ./autoswitch.nix {
    inherit pkgs cswap;
    inherit (cfg) primarySlot secondarySlot;
  };
in {
  options.programs.cswap = {
    primarySlot = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = "cswap slot (see `cswap list`) used while the weekly burndown is on or under budget. Must be a regular login, not a setup-token: the burndown is read from it.";
    };
    secondarySlot = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2;
      description = "cswap slot used while the primary's weekly burndown is over budget.";
    };
  };

  config = {
    home.packages = [cswap autoswitch];

    systemd.user.services.cswap-autoswitch = {
      Unit.Description = "Pick the Claude Code login from the primary's weekly burndown";
      Service = {
        Type = "oneshot";
        ExecStart = "${autoswitch}/bin/cswap-autoswitch";
      };
    };

    systemd.user.timers.cswap-autoswitch = {
      Unit.Description = "Re-check the weekly burndown and switch Claude Code login";
      Timer = {
        OnStartupSec = "2m";
        OnUnitActiveSec = "10m";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
