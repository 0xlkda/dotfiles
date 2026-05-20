#!/bin/bash
# Set @scroll-reversed per session so grouped iPad + Mac clients scroll
# independently. Bindings in tmux.conf read #{@scroll-reversed} at event time.
#
# Usage:
#   scroll-direction.sh detect <pid>   # iPad if sshd ancestor, else Mac
#   scroll-direction.sh toggle         # flip current session's direction
#   scroll-direction.sh apply <0|1>    # explicit set on current session

set -euo pipefail

mode="${1:-apply}"
pid=""

case "$mode" in
  detect)
    pid="${2:-$(tmux display-message -p '#{client_pid}')}"
    client_pid="$pid"     # preserve for client_session lookup; the loop mutates pid
    device="Mac"
    while [ "$pid" != "1" ] && [ -n "$pid" ]; do
      comm=$(ps -o comm= -p "$pid" 2>/dev/null | xargs)
      if [[ "$comm" == sshd* ]]; then
        device="iPad"
        break
      fi
      pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    done
    reverse=$([ "$device" = "iPad" ] && echo 1 || echo 0)
    # Apply to the session this client is attached to (not global)
    client_session=$(tmux list-clients -F '#{client_pid} #{client_session}' | awk -v p="$client_pid" '$1==p{print $2; exit}')
    [ -z "$client_session" ] && client_session=$(tmux display-message -p '#{client_session}')
    tmux set -t "$client_session" @scroll-reversed "$reverse"
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
