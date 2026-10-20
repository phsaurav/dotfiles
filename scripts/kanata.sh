#!/bin/bash
# Start kanata with the Karabiner VirtualHIDDevice daemon.
# Runs both in one terminal window; Ctrl+C stops both.
# Usage: sudo ~/dotfiles/scripts/kanata.sh

set -euo pipefail

DAEMON='/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'
CONFIG="$HOME/.config/kanata/kanata.kbd"
KANATA="$(command -v kanata || echo /opt/homebrew/bin/kanata)"

if [[ $EUID -ne 0 ]]; then
  echo "Needs root. Re-run: sudo $0" >&2
  exit 1
fi

# Resolve config for the invoking user, not root
if [[ -n "${SUDO_USER:-}" ]]; then
  CONFIG="$(eval echo "~$SUDO_USER")/.config/kanata/kanata.kbd"
fi

cleanup() {
  echo "Stopping daemon..."
  [[ -n "${DAEMON_PID:-}" ]] && kill "$DAEMON_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "Starting Karabiner VirtualHIDDevice daemon..."
"$DAEMON" &>/dev/null &
DAEMON_PID=$!
sleep 1

echo "Starting kanata ($CONFIG)..."
exec_result=0
"$KANATA" --cfg "$CONFIG" || exec_result=$?
exit $exec_result
