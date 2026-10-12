# herdr-pick (prefix+f): pick a URL or path from the focused pane, then copy
# or open it. Stands in for tmux-fingers / tmux-fzf-url, which herdr lacks.
#
#   enter   copy the match
#   ctrl-o  open the match
#
# Runs in a herdr popup. The popup is a terminal of its own, so the pane we
# want is the one herdr still reports as focused, never the popup itself.

read -r pane cwd < <(herdr pane list | jq -r --arg self "${HERDR_PANE_ID:-}" '
  [.result.panes[] | select(.focused and .pane_id != $self)][0]
  | "\(.pane_id // "") \(.foreground_cwd // .cwd // "")"')
[ -n "$pane" ] || exit 0

text=$(herdr pane read "$pane" --source recent-unwrapped --lines 5000)

url_re='(https?|file|ssh|git)://[^][:space:]"'"'"'<>`{}|\\^]+'
path_re='(~|\.\.?)?/?[[:alnum:]._@+-]+(/[[:alnum:]._@+-]+)+(:[0-9]+){0,2}'

# URLs first, then paths from the text with the URLs cut out, so a URL never
# also turns up as a stray path. Newest first (bottom of the pane), no repeats.
# Trailing sentence punctuation is almost never part of the match.
candidates=$(
  {
    grep -oE "$url_re" <<<"$text" || true
    sed -E "s#$url_re# #g" <<<"$text" | grep -oE "$path_re" | grep '[[:alpha:]]' || true
  } | sed -E 's/[].,;:)}>"'"'"']+$//' | tac | awk 'length > 2 && !seen[$0]++'
)
if [ -z "$candidates" ]; then
  echo "no URLs or paths in this pane"
  sleep 1
  exit 0
fi

out=$(fzf --no-sort --reverse --prompt='copy> ' \
  --header='enter: copy  ctrl-o: open' --expect=ctrl-o <<<"$candidates") || exit 0
key=$(head -n1 <<<"$out")
pick=$(sed -n 2p <<<"$out")
[ -n "$pick" ] || exit 0

# herdr-bridge opens or copies on the device herdr is attached from, and
# falls back to this host when you are sitting at it.
if [ "$key" = ctrl-o ]; then
  # A relative path only means something from the pane's own directory.
  if [ -n "$cwd" ]; then cd "$cwd" 2>/dev/null || true; fi
  exec herdr-bridge open "${pick%%:[0-9]*}"
fi
exec herdr-bridge copy "$pick"
