#!/usr/bin/env bash
# Claude Code status line command
# Displays: context used + raw tokens, 5h limit, 7d limit, weekly burndown
# (relative to the actual 7d reset time), and a weekday-only burndown.
# Color-coded: green=healthy, yellow=moderate, red=high/over
#
# Linked to ~/.claude/statusline-command.sh by default.nix in this directory.

input=$(cat)

# ANSI colors (will appear dimmed in the status line as Claude Code dims them)
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Color a value by threshold: color_pct <value> <yellow_threshold> <red_threshold> <label>
# value and thresholds are plain numbers (no % sign)
color_pct() {
  local val="$1" yellow_at="$2" red_at="$3" label="$4"
  local color
  if awk "BEGIN { exit !($val >= $red_at) }"; then
    color="$RED"
  elif awk "BEGIN { exit !($val >= $yellow_at) }"; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi
  # %b interprets the ANSI escapes in color/RESET; %s keeps the label literal so
  # its `%` (e.g. "ctx:37%") isn't mistaken for a printf format spec.
  printf '%b%s%b' "$color" "$label" "$RESET"
}

# Color burndown diff: green<=0, yellow 1-15, red >15
color_burndown() {
  local diff_val="$1" label="$2"
  local color
  if awk "BEGIN { exit !($diff_val > 15) }"; then
    color="$RED"
  elif awk "BEGIN { exit !($diff_val > 0) }"; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi
  # %b interprets the ANSI escapes in color/RESET; %s keeps the label literal so
  # its `%` (e.g. "ctx:37%") isn't mistaken for a printf format spec.
  printf '%b%s%b' "$color" "$label" "$RESET"
}

# Seconds falling on Mon-Fri (local time) within [start, end), walking day by day.
weekday_seconds() {
  local t="$1" end="$2" total=0 next
  while [ "$t" -lt "$end" ]; do
    next=$(date -d "$(date -d "@$t" +%F) + 1 day" +%s)
    [ "$next" -gt "$end" ] && next=$end
    if [ "$(date -d "@$t" +%u)" -le 5 ]; then
      total=$((total + next - t))
    fi
    t=$next
  done
  echo "$total"
}

# Context window usage
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Raw tokens currently in the context window (sum of the last API call's input +
# cache tokens). Fall back to size*used_percentage when current_usage is absent.
ctx_tokens=$(echo "$input" | jq -r '
  (.context_window.current_usage // {}) as $u
  | (($u.input_tokens // 0) + ($u.cache_read_input_tokens // 0) + ($u.cache_creation_input_tokens // 0)) as $sum
  | if $sum > 0 then $sum
    elif (.context_window.context_window_size // 0) > 0 and (.context_window.used_percentage // 0) > 0
      then ((.context_window.context_window_size) * (.context_window.used_percentage) / 100 | floor)
    else empty end')

# Rate limits: z.ai coding-plan quota endpoint (Anthropic-subscription rate_limit
# fields never arrive when Claude Code routes through z.ai's GLM endpoint).
# The endpoint returns data.limits[] entries; CREDIT_LIMIT with unit:3 is the
# 5-hour window, unit:6 the weekly one. percentage is used percent,
# nextResetTime is epoch milliseconds.
#
# Fail soft: any missing key/failure/parse gap leaves five_h etc. empty, which
# the panels below already handle by omitting themselves silently.
zai_cache="${XDG_RUNTIME_DIR:-/tmp}/zai-quota-cache.$UID.json"
zai_json=""

zai_fetch() {
  local key hdr
  [ -r "$HOME/.config/zai/key" ] || return 1
  IFS= read -r key < "$HOME/.config/zai/key" || return 1
  [ -n "$key" ] || return 1
  # Pass the key to curl via a temp config file so it never appears on the
  # command line (visible in ps) or in this script's output.
  hdr=$(mktemp) || return 1
  {
    printf 'silent\n'
    printf 'max-time = 5\n'
    printf 'header = "Authorization: %s"\n' "$key"
  } > "$hdr"
  curl --config "$hdr" -s --max-time 5 \
    'https://api.z.ai/api/monitor/usage/quota/limit' > "$zai_cache.tmp.$$" \
    && mv "$zai_cache.tmp.$$" "$zai_cache"
  local rc=$?
  rm -f "$hdr" "$zai_cache.tmp.$$"
  [ "$rc" -eq 0 ]
}

if [ -r "$zai_cache" ] && [ -n "$(find "$zai_cache" -mmin -1 2>/dev/null)" ]; then
  # Fresh cache: serve it without touching the endpoint.
  zai_json=$(cat "$zai_cache")
else
  if zai_fetch && jq -e '.code == 200' "$zai_cache" >/dev/null 2>&1; then
    zai_json=$(cat "$zai_cache")
  elif [ -r "$zai_cache" ]; then
    # Stale cache beats dropping the panels entirely.
    zai_json=$(cat "$zai_cache")
  fi
fi

five_h=$(printf '%s' "$zai_json" | jq -r '
  (.data.limits[]? | select(.type == "CREDIT_LIMIT" and .unit == 3) | .percentage) // empty')
seven_d=$(printf '%s' "$zai_json" | jq -r '
  (.data.limits[]? | select(.type == "CREDIT_LIMIT" and .unit == 6) | .percentage) // empty')
# nextResetTime is epoch milliseconds; the burndown math wants seconds.
seven_d_resets_at=$(printf '%s' "$zai_json" | jq -r '
  (.data.limits[]? | select(.type == "CREDIT_LIMIT" and .unit == 6) | (.nextResetTime / 1000 | floor)) // empty')

parts=()

# Context used: green <40%, yellow 40-79%, red >=80%
if [ -n "$ctx_used" ]; then
  if [ -n "$ctx_tokens" ] && [ "$ctx_tokens" -gt 0 ] 2>/dev/null; then
    tok_k=$(echo "$ctx_tokens" | awk '{ printf "%.0f", $1 / 1000 }')
    label=$(printf '📄 ctx:%.0f%% (%sk)' "$ctx_used" "$tok_k")
  else
    label=$(printf '📄 ctx:%.0f%%' "$ctx_used")
  fi
  parts+=("$(color_pct "$ctx_used" 40 80 "$label")")
fi

# 5-hour window: green <50%, yellow 50-75%, red >=75%
if [ -n "$five_h" ]; then
  label=$(printf '⏱ 5h:%.0f%%' "$five_h")
  parts+=("$(color_pct "$five_h" 50 75 "$label")")
fi

# 7-day window: green <50%, yellow 50-75%, red >=75%
if [ -n "$seven_d" ]; then
  label=$(printf '📅 7d:%.0f%%' "$seven_d")
  parts+=("$(color_pct "$seven_d" 50 75 "$label")")
fi

# Weekly burndown: compare 7-day used% against the linear fraction of the *current*
# 7-day window elapsed, derived from resets_at (when the window actually expires).
# Window start = resets_at - 7 days. If 7d used% > linear expectation => burning fast
# (over budget for how much of the window has elapsed), else under budget.
if [ -n "$seven_d" ] && [ -n "$seven_d_resets_at" ]; then
  now_epoch=$(date +%s)
  window_seconds=$((7 * 24 * 60 * 60))
  window_start=$((seven_d_resets_at - window_seconds))
  elapsed=$((now_epoch - window_start))
  # clamp elapsed into [0, window_seconds] in case of clock skew
  if [ "$elapsed" -lt 0 ]; then elapsed=0; fi
  if [ "$elapsed" -gt "$window_seconds" ]; then elapsed=$window_seconds; fi
  linear_pct=$(echo "$elapsed $window_seconds" | awk '{printf "%.1f", ($1 / $2) * 100}')
  # difference: positive means over budget (burning fast), negative means under budget
  diff_val=$(echo "$seven_d $linear_pct" | awk '{printf "%.1f", $1 - $2}')
  diff_label=$(echo "$diff_val" | awk '{
    if ($1 >= 0) { printf "📊 burndown:+%.0f%%", $1 }
    else         { printf "📊 burndown:%.0f%%",  $1 }
  }')
  parts+=("$(color_burndown "$diff_val" "$diff_label")")

  # Weekday burndown: same comparison, but the expected pace only advances on
  # Mon-Fri (local time), so weekends count as zero budget spent.
  wd_total=$(weekday_seconds "$window_start" "$seven_d_resets_at")
  wd_elapsed=$(weekday_seconds "$window_start" "$((window_start + elapsed))")
  if [ "$wd_total" -gt 0 ]; then
    wd_linear=$(echo "$wd_elapsed $wd_total" | awk '{printf "%.1f", ($1 / $2) * 100}')
    wd_diff=$(echo "$seven_d $wd_linear" | awk '{printf "%.1f", $1 - $2}')
    wd_label=$(echo "$wd_diff" | awk '{
      if ($1 >= 0) { printf "💼 weekday:+%.0f%%", $1 }
      else         { printf "💼 weekday:%.0f%%",  $1 }
    }')
    parts+=("$(color_burndown "$wd_diff" "$wd_label")")
  fi
fi

# Join with separator
printf '%s' "$(IFS='  │  '; echo "${parts[*]}")"
