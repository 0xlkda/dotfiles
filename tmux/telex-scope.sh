#!/usr/bin/env bash
# Tell GõTelex (macOS VN IME) the current scope so each tmux pane can have
# its own typing mode. No-op if telex isn't running.
[ -p /tmp/telex.cmd ] || exit 0
printf '{"name":"scopeSwitch","payload":{"scope":"%s"}}\n' "${1:-}" > /tmp/telex.cmd 2>/dev/null
