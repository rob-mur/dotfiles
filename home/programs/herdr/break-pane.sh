# herdr-break-pane (prefix+!): move the focused pane into a workspace of its
# own, like tmux's break-pane. The new workspace keeps the old one's label.
#
# Safe for ralph panes: a move gives the pane a new pane_id, but herdr still
# resolves the old id to the moved pane, so the in-container hook (which holds
# the launch-time HERDR_PANE_ID) keeps reporting to the right place. The
# terminal_id does not change at all.

read -r pane ws < <(herdr pane list | jq -r '
  [.result.panes[] | select(.focused)][0] | "\(.pane_id // "") \(.workspace_id // "")"')
[ -n "$pane" ] || exit 0

label=$(herdr workspace get "$ws" | jq -r '.result.workspace.label // empty')
herdr pane move "$pane" --new-workspace ${label:+--label "$label"} --focus >/dev/null
