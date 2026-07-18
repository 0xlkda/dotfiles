#!/usr/bin/env bash
# Attach a mobile client (iPhone, iPad, ...) to a PER-DEVICE grouped clone of
# the main tmux session.
#
# Why per-device: a grouped session shares the main session's windows but keeps
# independent per-client state (active window, copy-mode, status). Giving each
# device its OWN grouped session — lkda-iphone, lkda-ipad, ... — plus
# `aggressive-resize on` means a device only resizes the window it is
# *currently* viewing. So the iPad parked on a DIFFERENT window keeps its own
# full size and never touches the iPhone's screen.
#
# Hard tmux limit: a window has ONE size. When two devices view the SAME window
# it cannot fit both — so `window-size smallest` makes the smaller client (the
# phone) always win; the iPad shows that window letterboxed. The phone is never
# clipped or resized by the iPad. Want a full-size iPad view? Put it on its own
# window — aggressive-resize then isolates it completely.
#
# Device id resolution (first match wins):
#   1. $1                         explicit name        -> attach-mobile.sh ipad
#   2. $MOBILE_DEVICE             env from SSH client  -> export MOBILE_DEVICE=ipad
#   3. last octet of $SSH_CLIENT  auto-separate per host
#   4. "local"
#
# Usage:
#   attach-mobile.sh                 # device=auto,   main=lkda
#   attach-mobile.sh ipad            # device=ipad,   main=lkda -> lkda-ipad
#   attach-mobile.sh iphone work     # device=iphone, main=work -> work-iphone

set -euo pipefail

MAIN="${2:-lkda}"

device="${1:-${MOBILE_DEVICE:-}}"
if [ -z "$device" ]; then
  ip="${SSH_CLIENT%% *}"          # "ip port port" -> "ip"
  device="${ip:+ip-${ip##*.}}"    # last octet, stable per host on a network
  device="${device:-local}"
fi
device="$(printf '%s' "$device" | tr '.: ' '---')"  # tmux name: no . : space

MOBILE="${MAIN}-${device}"

# Ensure the main session exists (=name -> exact match, no prefix surprises).
tmux has-session -t "=$MAIN" 2>/dev/null || tmux new-session -d -s "$MAIN"

# Ensure this device's grouped clone exists.
tmux has-session -t "=$MOBILE" 2>/dev/null \
  || tmux new-session -d -s "$MOBILE" -t "$MAIN"

# -d detaches a stale client from THIS device (e.g. a dropped mobile link) so a
# reconnect doesn't leave a ghost client constraining the size.
exec tmux attach -d -t "=$MOBILE"
