# cswap-autoswitch: put Claude Code on the primary login while the weekly
# burndown is on or under budget, and on the secondary once it is over.
#
#   cswap-autoswitch             decide, and switch if the active login is wrong
#   cswap-autoswitch --dry-run   decide and print, never switch
#
# Environment (set by the Home Manager module, see default.nix):
#   CSWAP_PRIMARY_SLOT, CSWAP_SECONDARY_SLOT  cswap slot numbers (`cswap list`)
#   CSWAP_BURNDOWN_LIB                        ../claude-code/burndown.sh
#
# Whose burndown: always the PRIMARY's, whichever login is active. `cswap list
# --json` reads every stored account's 7-day usage from Anthropic's usage
# endpoint with that account's own stored login. That endpoint is not
# inference, so it spends no quota. While the secondary is active the primary
# sits idle, its used % stays put and the elapsed fraction of its window keeps
# growing, so its burndown falls on its own until it reaches zero and the
# primary takes over again. The formula is the status line's, from
# burndown.sh. A primary registered as a setup-token has no usage reading, so
# there the script holds the current login and says so.

set -euo pipefail

dry_run=0
case "${1-}" in
  --dry-run) dry_run=1 ;;
  "") ;;
  *)
    echo "usage: cswap-autoswitch [--dry-run]" >&2
    exit 2
    ;;
esac

primary=${CSWAP_PRIMARY_SLOT:?CSWAP_PRIMARY_SLOT is not set}
secondary=${CSWAP_SECONDARY_SLOT:?CSWAP_SECONDARY_SLOT is not set}

# shellcheck source=/dev/null
source "${CSWAP_BURNDOWN_LIB:?CSWAP_BURNDOWN_LIB is not set}"

log() { echo "cswap-autoswitch: $*"; }

# An exported token outranks every stored login, so a switch would change
# nothing Claude Code can see.
if [ -n "${CLAUDE_CODE_OAUTH_TOKEN-}" ]; then
  log "warning: CLAUDE_CODE_OAUTH_TOKEN is set here and overrides any switch; unset it"
fi

if ! accounts=$(cswap list --json); then
  log "cswap list failed; leaving the active login alone"
  exit 1
fi

active=$(jq -r '.activeAccountNumber // "none"' <<<"$accounts")

# Tab-separated usage status, 7-day used %, and 7-day reset time of the primary.
reading=$(jq -r --argjson p "$primary" '
  .accounts[] | select(.number == $p)
  | [.usageStatus, (.usage.sevenDay.pct // ""), (.usage.sevenDay.resetsAt // "")]
  | @tsv' <<<"$accounts")
if [ -z "$reading" ]; then
  log "primary slot $primary is not a managed account (see: cswap list); leaving active=$active"
  exit 1
fi
IFS=$'\t' read -r status used resets_iso <<<"$reading"

if [ "$status" != ok ] || [ -z "$used" ] || [ -z "$resets_iso" ]; then
  log "no usable weekly reading for primary slot $primary (usage: $status); leaving active=$active"
  exit 0
fi

resets_at=$(date -d "$resets_iso" +%s)
diff=$(burndown_diff "$used" "$resets_at")

if awk -v d="$diff" 'BEGIN { exit !(d > 0) }'; then
  want=$secondary
  side="over budget, want secondary"
else
  want=$primary
  side="on or under budget, want primary"
fi
summary="primary slot $primary 7d=${used}% burndown=${diff}% ($side); active=$active"

if [ "$active" = "$want" ]; then
  log "$summary; no change"
  exit 0
fi
if [ "$active" != "$primary" ] && [ "$active" != "$secondary" ]; then
  log "$summary; active login is neither slot, leaving it"
  exit 0
fi
if [ "$dry_run" = 1 ]; then
  log "$summary; would switch to slot $want (dry run)"
  exit 0
fi

log "$summary; switching to slot $want"
cswap switch "$want" --json
