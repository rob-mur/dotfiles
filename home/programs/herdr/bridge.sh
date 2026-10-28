# herdr-bridge: open a URL or copy text on the device herdr is attached FROM.
#
#   herdr-bridge open <url>
#   herdr-bridge copy [text]        (reads stdin when no text is given)
#   herdr-bridge forward            (relay one raw request from stdin)
#
# `herdr-desk` on a laptop/phone reverse-forwards a desktop port of its own
# (HERDR_BRIDGE_PORTS, one per device, see default.nix) to a listener on that
# device. Try each in turn: with several devices attached, the first that
# acts wins. Nothing attached, or no device can do it (no clipboard tool, a
# host path to open): fall back to doing it here, plus an OSC 52 copy when
# run in herdr or over ssh (below).
#
# `forward` is the ralph containers' way in (the desktop relays their unix
# socket to it): pass the request on as-is, print the reply, no fallback.

op="${1:-}"
case "$op" in
  open) payload="${2:?usage: herdr-bridge open <url>}" ;;
  copy) if [ $# -ge 2 ]; then payload="$2"; else payload="$(cat)"; fi ;;
  forward) payload="$(cat; echo .)" payload="${payload%.}" ;;
  *) echo "usage: herdr-bridge open <url> | herdr-bridge copy [text] | herdr-bridge forward" >&2; exit 2 ;;
esac

if [ -n "${HERDR_BRIDGE:-}" ]; then
  addrs=("$HERDR_BRIDGE")
else
  addrs=()
  for port in ${HERDR_BRIDGE_PORTS:-47101}; do addrs+=("tcp:127.0.0.1:$port"); done
fi

# The listener answers "ok" only once it has acted. A relay or forward with
# nothing behind it accepts and then hangs up, which reads as a failure.
send_py='
import socket, sys
op, addrs = sys.argv[1], sys.argv[2:]
data = sys.stdin.buffer.read()
req = data if op == "forward" else op.encode() + b"\n" + data
reply = b"no\n"
for addr in addrs:
    kind, _, rest = addr.partition(":")
    try:
        if kind == "unix":
            s = socket.socket(socket.AF_UNIX)
            s.settimeout(3)
            s.connect(rest)
        else:
            host, _, port = rest.rpartition(":")
            s = socket.create_connection((host, int(port)), timeout=3)
        with s:
            s.sendall(req)
            s.shutdown(socket.SHUT_WR)
            reply = s.recv(16)
    except OSError:
        continue
    if reply.startswith(b"ok"):
        break
if op == "forward":
    sys.stdout.buffer.write(reply if reply.startswith(b"ok") else b"no\n")
sys.exit(0 if reply.startswith(b"ok") else 1)
'
if printf %s "$payload" | python3 -c "$send_py" "$op" "${addrs[@]}" 2>/dev/null; then exit 0; fi
[ "$op" = forward ] && exit 1

# Local fallback. No device acted: a phone has no clipboard tool, and opens
# nothing unless its config provides an opener. Acting on this machine alone
# would land on the desktop, out of sight. So inside a herdr pane or popup,
# copy with OSC 52 too. herdr hands that to the client you used last: the
# phone's terminal, or wl-copy on the desktop's own client. Over ssh it goes
# to the terminal you came from. Python's webbrowser starts the opener in a
# session of its own, without /dev/tty, but stderr is still the pane.
term=
if [ -n "${HERDR_ENV:-}${SSH_CONNECTION:-}" ]; then
  if { : >/dev/tty; } 2>/dev/null; then
    term=/dev/tty
  elif [ -t 2 ]; then
    term=/dev/stderr
  fi
fi
osc52() { printf '\e]52;c;%s\a' "$(printf %s "$1" | base64 | tr -d '\n')" >"${term:-/dev/tty}"; }

# The pane's own xdg-open and wl-copy (default.nix) send everything here, so
# tell them to be the real thing this time.
export HERDR_BRIDGE_ACTIVE=1

if [ "$op" = open ]; then
  # A path names a file here, which only this machine can open.
  if [ -n "$term" ] && [[ $payload == *://* ]]; then
    osc52 "$payload"
    link="$payload"
    [ -t 2 ] && link=$(printf '\e]8;;%s\a%s\e]8;;\a' "$payload" "$payload")
    echo "herdr-bridge: no attached device could open it, copied it to your clipboard: $link" >&2
  fi
  for opener in xdg-open open; do
    if command -v "$opener" >/dev/null; then
      setsid -f "$opener" "$payload" >/dev/null 2>&1 && exit 0
    fi
  done
  [ -n "$term" ] && exit 0
  echo "open: $payload" >&2
  exit 1
fi

if [ -n "$term" ]; then
  osc52 "$payload"
  exit 0
fi

# The herdr server (and so anything it spawns) often starts without
# WAYLAND_DISPLAY, which leaves wl-copy dead. Find the compositor socket.
if [ -z "${WAYLAND_DISPLAY:-}" ]; then
  for s in "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/wayland-[0-9]; do
    if [ -S "$s" ]; then export WAYLAND_DISPLAY="${s##*/}"; break; fi
  done
fi
if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null; then
  printf %s "$payload" | wl-copy
elif command -v pbcopy >/dev/null; then
  printf %s "$payload" | pbcopy
else
  # OSC 52: ask the terminal to set the clipboard.
  osc52 "$payload"
fi
