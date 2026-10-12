# herdr-bridge: open a URL or copy text on the device herdr is attached FROM.
#
#   herdr-bridge open <url>
#   herdr-bridge copy [text]        (reads stdin when no text is given)
#
# `herdr-desk` on a laptop/phone reverse-forwards 127.0.0.1:47101 on the
# desktop to a listener on that device (see default.nix). Nothing attached,
# or the device can't do it (no clipboard tool, a host path to open): fall
# back to doing it here.

op="${1:-}"
case "$op" in
  open) payload="${2:?usage: herdr-bridge open <url>}" ;;
  copy) if [ $# -ge 2 ]; then payload="$2"; else payload="$(cat)"; fi ;;
  *) echo "usage: herdr-bridge open <url> | herdr-bridge copy [text]" >&2; exit 2 ;;
esac

addr="${HERDR_BRIDGE:-tcp:127.0.0.1:47101}"

# The listener answers "ok" only once it has acted. A relay or forward with
# nothing behind it accepts and then hangs up, which reads as a failure.
send_py='
import socket, sys
addr, op = sys.argv[1], sys.argv[2]
data = sys.stdin.buffer.read()
kind, _, rest = addr.partition(":")
try:
    if kind == "unix":
        s = socket.socket(socket.AF_UNIX)
        s.settimeout(3)
        s.connect(rest)
    else:
        host, _, port = rest.rpartition(":")
        s = socket.create_connection((host, int(port)), timeout=3)
    s.sendall(op.encode() + b"\n" + data)
    s.shutdown(socket.SHUT_WR)
    reply = s.recv(16)
except OSError:
    sys.exit(1)
sys.exit(0 if reply.startswith(b"ok") else 1)
'
if printf %s "$payload" | python3 -c "$send_py" "$addr" "$op" 2>/dev/null; then exit 0; fi

# Local fallback.
if [ "$op" = open ]; then
  for opener in xdg-open open; do
    if command -v "$opener" >/dev/null; then
      setsid -f "$opener" "$payload" >/dev/null 2>&1 && exit 0
    fi
  done
  echo "open: $payload" >&2
  exit 1
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
  printf '\e]52;c;%s\a' "$(printf %s "$payload" | base64 | tr -d '\n')" >/dev/tty
fi
