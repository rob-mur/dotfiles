#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash|Monitor|Agent|SendMessage) - keep sub-agent prompt caches warm.
# PROTOTYPE for ~/.claude/hooks/subagent-wait-guard.sh (dotfiles); not installed.
#
# v1 (unchanged): sub-agents get a 5-minute prompt-cache TTL, so a single Bash call that runs
# longer than that makes the next call rewrite the whole context.  Inside a sub-agent (hook input
# carries agent_id) a foreground Bash timeout above 270 s is lowered to 270 s.  A command still
# running at its timeout moves to the background (it is not killed), so the sub-agent gets a turn -
# and a cache refresh - before the 5 minutes are up, and is told to wait on in slices.
# Only in bypassPermissions sessions: updatedInput must be paired with "allow", which elsewhere
# would skip a permission prompt.  Top-level sessions (1-hour cache) are never touched.
#
# v2 adds two advisory notes.  They carry additionalContext only (no permission decision, no
# changed input), so they are safe in every permission mode:
#   - inside a sub-agent, a background launch (Bash run_in_background, Monitor, Agent
#     run_in_background): do not end the turn to wait for it; poll in slices under 270 s;
#   - a SendMessage (from any context) to a sub-agent whose transcript has been idle > 300 s:
#     its cache has expired, so the message rewrites its whole context; the note gives that
#     context size and suggests a fresh agent with a short handoff when history is not needed.
# Any error or unexpected input exits 0 with no output, so the tool call proceeds unchanged.
set -uo pipefail
in=$(cat) || exit 0
q() { jq -r "$1" <<<"$in" 2>/dev/null; }
note() {
  jq -n --arg c "$1" '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: $c}}'
  exit 0
}
BG="Sub-agent cache expires after 5 min idle: do not end your turn to wait for this background task. If you need its result, wait in foreground slices under 270 s (for example sleep 240, then check). If it will take over 30 minutes, return a short handoff to your caller instead."

tool=$(q '.tool_name // ""') || exit 0
agent=$(q '.agent_id // ""') || exit 0
case $tool in
  Bash)
    [ -n "$agent" ] || exit 0
    if jq -e '.permission_mode == "bypassPermissions"
              and ((.tool_input.run_in_background // false) | not)
              and ((.tool_input.timeout // 0) > 270000)' >/dev/null 2>&1 <<<"$in"; then
      jq '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow",
        updatedInput: (.tool_input + {timeout: 270000}),
        additionalContext: "Sub-agent cache expires after 5 min idle: if this moved to the background, wait in foreground slices under 270 s, not by ending your turn."}}' <<<"$in" || true
      exit 0
    fi
    [ "$(q '.tool_input.run_in_background // false')" = true ] && note "$BG"
    ;;
  Monitor)
    [ -n "$agent" ] && note "$BG"
    ;;
  Agent)
    [ -n "$agent" ] && [ "$(q '.tool_input.run_in_background // false')" = true ] && note "$BG"
    ;;
  SendMessage)
    to=$(q '.tool_input.to // ""')
    tp=$(q '.transcript_path // ""')
    [[ $to =~ ^[A-Za-z0-9_-]+$ ]] && [[ $tp == *.jsonl ]] || exit 0
    case $tp in
      */subagents/*) dir=${tp%/*} ;;
      *) dir=${tp%.jsonl}/subagents ;;
    esac
    f=$dir/agent-$to.jsonl
    [ -f "$f" ] || exit 0
    idle=$(( $(date +%s) - $(stat -c %Y "$f" 2>/dev/null || date +%s) ))
    [ "$idle" -gt 300 ] || exit 0
    size=$(tac "$f" 2>/dev/null | grep -m1 '"cache_read_input_tokens"' |
      jq -r '.message.usage | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)' 2>/dev/null)
    [[ $size =~ ^[0-9]+$ ]] || size="its whole"
    note "Agent $to has been idle ${idle} s, so its prompt cache has expired: this message makes it rewrite ${size} tokens of context at cache-write price before it replies. If the follow-up does not need its history, start a fresh Agent with a short handoff instead."
    ;;
esac
exit 0
