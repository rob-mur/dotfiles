# Poller: give every herdr agent row a sticky SUBJECT — the topic of
# that session — instead of a shared placeholder like "ralph-work".
#
# HOW: Claude (and codex) set the terminal title to the task they are on, and
# that OSC title reaches herdr even from inside a ralph container, because
# `docker run -it` passes the container's stdout straight through the herdr
# pane. herdr exposes it as `terminal_title_stripped`. We copy it onto the pane
# as metadata — `herdr pane report-metadata --token subject=...` — which the
# sidebar renders through the `$subject` row token (see config.toml).
#
# WHY METADATA, NOT THE terminal_title ROW: the live title is not sticky.
# Claude sets a task title only while its MAIN thread works a turn; when the
# main thread parks at the prompt (idle, or waiting on a subagent) it resets the
# title to "Claude Code". A `terminal_title` row therefore flips back to
# "Claude Code" exactly when you are scanning the sidebar for what each agent is
# doing. The token keeps the last meaningful title, so the subject persists.
#
# WHY PER-PANE, NOT PER-WORKSPACE: this used to rename each agent's workspace,
# because the workspace label was the only bold element herdr rendered. That
# broke as soon as one workspace held two agents — both rows then showed the one
# workspace label. Metadata is per pane, so every agent carries its own subject.
#
# WHY A POLLER (not a herdr plugin): herdr only emits pane events for the
# FOCUSED pane, container agents stay status=unknown, and plugins cannot
# register a timer. An event-driven plugin would update the focused agent and
# never the background ones — the case that matters when several ralphs run.
#
# WHY A SYSTEMD SERVICE: the poller used to be started by ralph-code's `herd`
# and devenv enterShell, and exited with the server. A server started anywhere
# else (any directory, `herdr-desk`, a restart) then ran with no poller at all.
# The user service is the singleton, and the poller outlives server restarts:
# while no server answers it just waits for the next one.

INTERVAL="${HERD_SUBJECT_POLL_INTERVAL:-3}"
# Metadata is keyed by source, so herdr can tell our writes from an agent
# integration's own reports.
SOURCE="ralph-subject"
# Match sidebar_max_width in the herdr config, so a long title cannot squeeze
# the state icon off the row.
MAX_LEN=48

while true; do
  # A failed call means no server is running (or it is restarting): wait for
  # the next one.
  if ! agents=$(herdr agent list 2>/dev/null) ||
    ! workspaces=$(herdr workspace list 2>/dev/null); then
    sleep "$INTERVAL"
    continue
  fi

  # One line per agent: pane_id, live title, subject we set last time, and the
  # workspace label to fall back on before any real title exists.
  #
  # Fields are joined with US (0x1f), not a tab: tab is an IFS whitespace
  # character, so `read` collapses runs of them and an empty field (an agent with
  # no subject yet) would silently shift every later field left. US is not
  # whitespace, so each empty field keeps its place.
  jq -n -r --argjson a "$agents" --argjson w "$workspaces" '
    ($w.result.workspaces | map({key: .workspace_id, value: (.label // .name // "")}) | from_entries) as $labels
    | $a.result.agents[]
    | [ .pane_id,
        (.terminal_title_stripped // ""),
        (.tokens.subject // ""),
        ($labels[.workspace_id] // "") ]
    | join("\u001f")' \
  | while IFS=$'\x1f' read -r pane title subject ws_label; do
      # Trim, then drop any leading status glyph/spinner Claude prefixes.
      title="${title#"${title%%[![:space:]]*}"}"
      title="${title%"${title##*[![:space:]]}"}"
      stripped="${title#"${title%%[[:alpha:]]*}"}"

      # An agent parked at its prompt reports only its placeholder title. Keep
      # whatever subject we already have rather than regress the row to it.
      case "$stripped" in
        "" | "Claude Code" | "Codex" | "codex") next="$subject" ;;
        *) next="$stripped" ;;
      esac

      # Nothing meaningful yet: seed from the workspace label so the row is
      # never blank while an agent starts up.
      [ -n "$next" ] || next="$ws_label"
      [ -n "$next" ] || continue

      [ "${#next}" -gt "$MAX_LEN" ] && next="${next:0:$((MAX_LEN - 1))}…"
      [ "$next" = "$subject" ] && continue

      # --title as well as the token: it also labels split-pane borders, and it
      # costs nothing to keep the two in step.
      herdr pane report-metadata "$pane" --source "$SOURCE" \
        --token subject="$next" --title "$next" >/dev/null 2>&1 || true
    done

  sleep "$INTERVAL"
done
