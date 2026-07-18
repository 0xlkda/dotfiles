#!/bin/bash
# Set @scroll-reversed per session. Bindings in tmux.conf read
# #{@scroll-reversed} at event time. Auto-reverse is disabled: detect always
# pins normal (0); reverse is opt-in per session via prefix+S.
#
# Usage:
#   scroll-direction.sh detect <pid>   # pin the attaching session to normal (0)
#   scroll-direction.sh toggle         # flip current session's direction
#   scroll-direction.sh apply <0|1>    # explicit set on current session

set -euo pipefail

mode="${1:-apply}"
pid=""

case "$mode" in
  detect)
    # Auto-reverse disabled: pin the attaching session to normal (0).
    # Reverse is opt-in per session via prefix+S (toggle below).
    client_pid="${2:-$(tmux display-message -p '#{client_pid}')}"
    # Apply to the session this client is attached to (not global)
    client_session=$(tmux list-clients -F '#{client_pid} #{client_session}' | awk -v p="$client_pid" '$1==p{print $2; exit}')
    [ -z "$client_session" ] && client_session=$(tmux display-message -p '#{client_session}')
    tmux set -t "$client_session" @scroll-reversed 0
    exit 0
    ;;

  toggle)
    current=$(tmux display-message -p '#{@scroll-reversed}')
    [ "$current" = "1" ] && reverse=0 || reverse=1
    client_session=$(tmux list-clients -F '#{client_pid} #{client_session}' | awk -v p="$pid" '$1==p{print $2; exit}')
    [ -z "$client_session" ] && client_session=$(tmux display-message -p '#{client_session}')
    tmux set -t "$client_session" @scroll-reversed "$reverse"
    label=$([ "$reverse" = 1 ] && echo Reversed || echo Normal)
    tmux display "Scroll: $label ($client_session)"
    ;;

  apply)
    reverse="${2:-0}"
    client_session=$(tmux list-clients -F '#{client_pid} #{client_session}' | awk -v p="$pid" '$1==p{print $2; exit}')
    [ -z "$client_session" ] && client_session=$(tmux display-message -p '#{client_session}')
    tmux set -t "$client_session" @scroll-reversed "$reverse"
    ;;
esac
