# firstmate — run kunchenguid/firstmate as the dispatcher for ralph work.
#
# The first mate is a host Claude session in the firstmate checkout. It spawns
# one crewmate per YouTrack issue into a treehouse worktree of the issue's repo,
# and each crewmate runs ralph's per-issue pipeline there (see
# captain-ralph.md). Its toolchain - treehouse, no-mistakes, tea and the AXI
# CLIs - is in home.packages (./default.nix), not only on this script's PATH:
# every crewmate pane starts a fresh login shell, and that shell must find them.
#
# Every launch first seeds the firstmate home, idempotently:
#   - clones firstmate to $FIRSTMATE_ROOT if it is missing
#   - selects the herdr backend and the claude crew harness (only when unset)
#   - rewrites the ralph block of data/captain.md from captain-ralph.md
#   - registers and clones every repo in ~/.config/youtrack/subsystems.json as a
#     `direct-PR branch=` project, so ship branches are ralph's <issue-id>-<slug>
#
# The first mate runs on $FIRSTMATE_MODEL (default haiku) and only routes work;
# crewmates, secondmates and firstmate-desk sessions take the system default
# model. Pass it as --model, never as an exported variable, so none of them
# inherits it.
#
# Usage:  firstmate           seed, then open the first mate in a herdr workspace
#         firstmate --here    seed, then run the first mate in this terminal
#         firstmate --seed    seed only

root="${FIRSTMATE_ROOT:-$HOME/repos/firstmate}"
subsystems="$HOME/.config/youtrack/subsystems.json"
model="${FIRSTMATE_MODEL:-haiku}"
mode="${1:-herdr}"

[ -d "$root/.git" ] || git clone https://github.com/kunchenguid/firstmate "$root"
mkdir -p "$root/config" "$root/data" "$root/projects"

[ -s "$root/config/backend" ] || echo herdr >"$root/config/backend"
[ -s "$root/config/crew-harness" ] || echo claude >"$root/config/crew-harness"

# Firstmate curates data/captain.md itself, so only the marked block is ours.
captain="$root/data/captain.md"
begin='<!-- ralph-code:begin -->'
end='<!-- ralph-code:end -->'
[ -f "$captain" ] || printf '# Captain preferences\n' >"$captain"
tmp=$(mktemp)
awk -v b="$begin" -v e="$end" '$0==b{skip=1} !skip{print} $0==e{skip=0}' "$captain" >"$tmp"
{ printf '\n%s\n' "$begin"; cat "$FIRSTMATE_CAPTAIN_BLOCK"; printf '%s\n' "$end"; } >>"$tmp"
# Drop the blank lines the previous block left behind, so reseeding is stable.
cat -s "$tmp" >"$captain"
rm -f "$tmp"

registry="$root/data/projects.md"
[ -f "$registry" ] || printf '# Projects\n\n' >"$registry"
if [ -f "$subsystems" ]; then
  jq -r 'to_entries[] | .key as $s | .value[] | [$s, .role, .url] | @tsv' "$subsystems" |
    while IFS=$'\t' read -r subsystem role url; do
      name=$(basename "$url" .git)
      if [ ! -d "$root/projects/$name" ]; then
        echo "firstmate: cloning $name" >&2
        git clone --quiet "$url" "$root/projects/$name" </dev/null
      fi
      grep -q "^- $name \[" "$registry" ||
        echo "- $name [direct-PR branch=] - YouTrack subsystem $subsystem: $role (added $(date +%F))" >>"$registry"
    done
else
  echo "firstmate: $subsystems not found; no projects registered" >&2
fi

[ "$mode" = --seed ] && exit 0

# shellcheck disable=SC2016 # $0 and $1 expand in the inner bash, not here.
launch=(env FM_BACKEND=herdr bash -c 'cd "$0" && exec claude --model "$1"' "$root" "$model")

if [ "$mode" = --here ]; then
  exec "${launch[@]}"
fi

# Crewmate tabs open beside the launching pane, so the first mate gets its own
# workspace, as herd gives each ralph.
ws_id=$(herdr workspace create --cwd "$root" --label firstmate --focus |
  jq -r '.result.workspace.workspace_id // empty')
[ -n "$ws_id" ] || { echo "firstmate: could not create a herdr workspace" >&2; exit 1; }
pane=$(herdr pane list --workspace "$ws_id" | jq -r '.result.panes[0].pane_id // empty')
[ -n "$pane" ] || { echo "firstmate: workspace $ws_id has no pane" >&2; exit 1; }
herdr pane run "$pane" "exec $(printf '%q ' "${launch[@]}")" >/dev/null
