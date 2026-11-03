# nix flake check: prefix+f, pick a URL, ctrl-o must reach the opener.
#
# Drives the real thing in the build sandbox: a herdr server and client (in a
# tmux window for a terminal) on this repo's config.toml, the installed
# herdr-pick and herdr-bridge, and a stub xdg-open that records what it is
# asked to open. Nothing is listening on the bridge ports here, so
# herdr-bridge takes its local fallback, which is the path at the desk.
#
# Real xdg-open takes about 0.2 s to hand the URL to Firefox. The popup closes
# as soon as herdr-pick exits, and anything still holding its terminal gets a
# SIGHUP then. The stub waits a second before recording, so an opener that
# dies with the popup never records.
{pkgs}: let
  inherit (import ./packages.nix {inherit pkgs;}) herdr herdrPick;
  opener = pkgs.writeShellScriptBin "xdg-open" ''
    sleep 1
    printf '%s\n' "$*" >> "$OPENED"
  '';
in
  pkgs.runCommand "herdr-pick-open-check" {
    nativeBuildInputs = with pkgs; [herdr herdrPick opener tmux jq zsh coreutils gnugrep];
  } ''
    export HOME=$TMPDIR/home TMUX_TMPDIR=$TMPDIR/tmux TERM=xterm-256color
    export OPENED=$TMPDIR/opened HERDR_CONFIG_PATH=$HOME/.config/herdr/config.toml
    mkdir -p "$HOME/.config/herdr" "$TMUX_TMPDIR"
    install -m 644 ${./config.toml} "$HERDR_CONFIG_PATH"
    touch "$HOME/.zshrc" # no zsh-newuser-install prompt in the pane
    url=https://example.com/herdr-pick-check

    h() { herdr "$@" --session check; }
    screen() { tmux capture-pane -p -t check; }
    fail() {
      echo "FAIL: $*"
      echo "--- herdr client screen:"
      screen || true
      exit 1
    }
    # until <seconds> <command...>: retry every 0.1 s.
    until_ok() {
      local n=$(($1 * 10))
      shift
      while ! "$@" >/dev/null 2>&1; do
        n=$((n - 1))
        [ "$n" -gt 0 ] || return 1
        sleep 0.1
      done
    }

    herdr server --session check >"$TMPDIR/server.log" 2>&1 &
    until_ok 20 sh -c 'herdr status --json --session check | jq -e .server.running' \
      || fail "herdr server did not start: $(cat "$TMPDIR/server.log")"

    tmux -f /dev/null new-session -d -s check -x 200 -y 50 herdr --session check
    until_ok 20 sh -c 'herdr pane list --session check | jq -e ".result.panes[0].pane_id"' \
      || fail "herdr client did not attach"
    pane=$(h pane list | jq -r '.result.panes[0].pane_id')
    until_ok 20 sh -c "tmux capture-pane -p -t check | grep -q '%'" || fail "no shell prompt"

    h pane send-text "$pane" "echo $url" >/dev/null
    h pane send-keys "$pane" Enter >/dev/null
    until_ok 10 sh -c "herdr pane read $pane --source visible --session check | grep -qx '$url'" \
      || fail "URL not on screen"

    tmux send-keys -t check C-a
    sleep 0.3
    tmux send-keys -t check f
    until_ok 10 sh -c "tmux capture-pane -p -t check | grep -q 'ctrl-o: open'" \
      || fail "prefix+f did not open the herdr-pick popup"
    tmux send-keys -t check -l herdr-pick-check
    sleep 0.5
    tmux send-keys -t check C-o
    until_ok 10 sh -c "! tmux capture-pane -p -t check | grep -q 'ctrl-o: open'" \
      || fail "ctrl-o did not close the popup"

    until_ok 5 test -s "$OPENED" || fail "ctrl-o closed the popup, but the opener never received $url"
    [ "$(cat "$OPENED")" = "$url" ] || fail "opener received '$(cat "$OPENED")', want '$url'"
    echo "ok: prefix+f, ctrl-o opened $url"
    touch $out
  ''
