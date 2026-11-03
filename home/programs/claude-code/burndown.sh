# shellcheck shell=bash
# Weekly burndown arithmetic, shared by the status line
# (statusline-command.sh) and the cswap account switcher (../cswap), so the
# two cannot drift apart. Sourced, never executed.
#
# Burndown compares the 7-day used % against the linear fraction of the
# *current* 7-day window that has elapsed, derived from resets_at (when the
# window actually expires). Window start = resets_at - 7 days. Positive means
# over budget for how much of the window has passed (burning fast); zero or
# negative means on or under budget.
#
# BURNDOWN_NOW overrides the clock (epoch seconds), for tests.

BURNDOWN_WINDOW_SECONDS=$((7 * 24 * 60 * 60))

# burndown_elapsed <resets_at_epoch>
# Seconds into the current window, clamped to [0, window] against clock skew.
burndown_elapsed() {
  local resets_at="$1" now window_start elapsed
  now=${BURNDOWN_NOW:-$(date +%s)}
  window_start=$((resets_at - BURNDOWN_WINDOW_SECONDS))
  elapsed=$((now - window_start))
  if [ "$elapsed" -lt 0 ]; then elapsed=0; fi
  if [ "$elapsed" -gt "$BURNDOWN_WINDOW_SECONDS" ]; then elapsed=$BURNDOWN_WINDOW_SECONDS; fi
  echo "$elapsed"
}

# burndown_diff <used_pct> <resets_at_epoch>
# Prints used % minus the linear expectation, one decimal (e.g. 3.2, -11.0).
burndown_diff() {
  local used="$1" resets_at="$2" elapsed linear_pct
  elapsed=$(burndown_elapsed "$resets_at")
  linear_pct=$(echo "$elapsed $BURNDOWN_WINDOW_SECONDS" | awk '{printf "%.1f", ($1 / $2) * 100}')
  echo "$used $linear_pct" | awk '{printf "%.1f", $1 - $2}'
}
