#!/usr/bin/env bash
# Attach iPad/mobile client to a grouped clone of the main tmux session.
# Grouped session: same windows, independent per-client state (active window,
# copy-mode, etc.) — prevents copy-mode overlay leak across clients of
# different sizes/renderers.
#
# Usage:
#   attach-mobile.sh            # main=lkda, mobile=lkda-mobile
#   attach-mobile.sh foo        # main=foo,  mobile=foo-mobile

set -euo pipefail

MAIN="${1:-lkda}"
MOBILE="${MAIN}-mobile"

if ! tmux has-session -t "$MAIN" 2>/dev/null; then
  tmux new-session -d -s "$MAIN"
fi

if ! tmux has-session -t "$MOBILE" 2>/dev/null; then
  tmux new-session -d -s "$MOBILE" -t "$MAIN"
fi

exec tmux attach -t "$MOBILE"
