# firstmate-desk — open an interactive Claude session for the captain.
#
# The first mate runs on a small, quick model and only routes work (see
# captain-ralph.md). Sessions the captain takes part in, such as grilling or an
# interactive review, need the system default model instead, so the first mate
# opens them here: a new herdr tab in its own workspace, running `claude` with no
# --model in <dir>, started with <prompt>. The tab label goes to stdout so the
# first mate can tell the captain which tab to switch to.
#
# Usage:  firstmate-desk <dir> <prompt>
#   e.g.  firstmate-desk ~/repos/app '/grill-priors https://youtrack.example/issue/APP-5286'

[ $# -eq 2 ] || { echo "usage: firstmate-desk <dir> <prompt>" >&2; exit 2; }
dir=$(realpath "$1")
prompt=$2
[ -d "$dir" ] || { echo "firstmate-desk: $dir is not a directory" >&2; exit 1; }

# The first mate's pane carries its workspace id; outside herdr, find the
# workspace firstmate.sh created by its label.
ws_id="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws_id" ] || ws_id=$(herdr workspace list |
  jq -r '[.result.workspaces[] | select(.label == "firstmate")][0].workspace_id // empty')
[ -n "$ws_id" ] || { echo "firstmate-desk: no firstmate herdr workspace" >&2; exit 1; }

label="desk $(basename "$dir") $(date +%H%M)"
pane=$(herdr tab create --workspace "$ws_id" --cwd "$dir" --label "$label" --no-focus |
  jq -r '.result.root_pane.pane_id // empty')
[ -n "$pane" ] || { echo "firstmate-desk: could not create a herdr tab" >&2; exit 1; }
herdr pane run "$pane" "exec claude $(printf '%q' "$prompt")" >/dev/null
echo "$label"
