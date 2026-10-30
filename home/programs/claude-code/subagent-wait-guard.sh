#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash) - keep sub-agent prompt caches warm.
# Sub-agents get a 5-minute prompt-cache TTL, so a single Bash call that runs
# longer than that makes the next call rewrite the whole context.  Inside a
# sub-agent (hook input carries agent_id) a foreground Bash timeout above
# 270 s is lowered to 270 s.  A command still running at its timeout moves to
# the background (it is not killed), so the sub-agent gets a turn - and a
# cache refresh - before the 5 minutes are up, and is told to wait on in
# slices.  Calls that finish sooner are unaffected.
# Only in bypassPermissions sessions: updatedInput must be paired with
# "allow", which elsewhere would skip a permission prompt.
# Top-level sessions (no agent_id, 1-hour cache) are never touched.
set -euo pipefail
in=$(cat)
jq -e '(.agent_id // "") != "" and .tool_name == "Bash" and .permission_mode == "bypassPermissions"
       and ((.tool_input.run_in_background // false) | not)
       and ((.tool_input.timeout // 0) > 270000)' >/dev/null <<<"$in" || exit 0
jq '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow",
  updatedInput: (.tool_input + {timeout: 270000}),
  additionalContext: "Sub-agent cache expires after 5 min idle: if this moved to the background, wait in foreground slices under 270 s, not by ending your turn."}}' <<<"$in"
