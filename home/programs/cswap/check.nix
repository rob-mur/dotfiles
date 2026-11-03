# nix flake check: cswap-autoswitch picks the login the weekly burndown calls
# for. Runs the real script against a stub `cswap` that serves a canned
# `list --json` and records any `switch`, on a fixed clock. Nothing here
# touches a credential.
{pkgs}: let
  # Stands in for cswap. FIXTURE is the `list --json` reply; a switch is
  # appended to SWITCHED.
  stub = pkgs.writeShellScriptBin "cswap" ''
    case "$1" in
      list) cat "$FIXTURE" ;;
      switch) echo "$2" >> "$SWITCHED"; echo '{"switched": true}' ;;
      *) echo "stub cswap: unexpected $*" >&2; exit 64 ;;
    esac
  '';
  autoswitch = import ./autoswitch.nix {
    inherit pkgs;
    cswap = stub;
    primarySlot = 1;
    secondarySlot = 2;
  };
in
  pkgs.runCommand "cswap-autoswitch-check" {
    nativeBuildInputs = [autoswitch pkgs.jq pkgs.coreutils pkgs.gnugrep];
  } ''
    export FIXTURE=$TMPDIR/list.json SWITCHED=$TMPDIR/switched
    # Window 2026-11-01..2026-11-08 UTC; now is half way through it (50%).
    export BURNDOWN_NOW=$(date -u -d 2026-11-04T12:00:00Z +%s)
    resets=2026-11-08T00:00:00Z

    # run <active> <usageStatus> <primary 7d %> <expected switch target or ->
    run() {
      active=$1 status=$2 pct=$3 expect=$4
      : > "$SWITCHED"
      jq -n --argjson a "$active" --arg s "$status" --argjson p "$pct" --arg r "$resets" '
        {activeAccountNumber: $a, accounts: [
          {number: 1, usageStatus: $s,
           usage: (if $s == "ok" then {sevenDay: {pct: $p, resetsAt: $r}} else null end)},
          {number: 2, usageStatus: "unavailable", usage: null}]}' > "$FIXTURE"
      msg=$(cswap-autoswitch) || { echo "FAIL ($*): exit $?: $msg"; exit 1; }
      got=$(tr -d '\n' < "$SWITCHED"); got=''${got:--}
      [ "$got" = "$expect" ] || { echo "FAIL ($*): switched to $got, wanted $expect"; echo "$msg"; exit 1; }
      echo "ok ($*): $msg"
    }

    # active status pct -> expected switch
    run 1 ok 60 2   # +10% over budget, primary active: go to the secondary
    run 1 ok 50 -   # exactly on budget: stay on the primary
    run 1 ok 40 -   # under budget, on the primary: nothing to do
    run 2 ok 60 -   # still over budget, on the secondary: stay
    run 2 ok 50 1   # back on budget: return to the primary
    run 2 ok 10 1   # well under: return to the primary
    run 1 unavailable 0 -   # primary unreadable: hold, whatever is active
    run 2 unavailable 0 -
    run 3 ok 90 -   # some third login is active: leave it alone

    # --dry-run decides but never switches.
    : > "$SWITCHED"
    jq -n --arg r "$resets" '{activeAccountNumber: 1, accounts: [
      {number: 1, usageStatus: "ok", usage: {sevenDay: {pct: 90, resetsAt: $r}}}]}' > "$FIXTURE"
    cswap-autoswitch --dry-run | grep -q "would switch to slot 2"
    [ ! -s "$SWITCHED" ] || { echo "FAIL: --dry-run switched"; exit 1; }

    # A window that already reset: used % reads as under budget.
    BURNDOWN_NOW=$(date -u -d 2026-11-09T00:00:00Z +%s) cswap-autoswitch --dry-run | grep -q "burndown=-"

    touch $out
  ''
