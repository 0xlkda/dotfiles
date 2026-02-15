#!/bin/bash
# Usage: scroll-direction.sh detect <pid> | apply [0|1] | toggle
mode=${1:-apply}

if [ "$mode" = "detect" ]; then
  # Lock to prevent concurrent runs (hook + click + config load can race)
  LOCKDIR="/tmp/tmux-active-device.lock"
  if ! mkdir "$LOCKDIR" 2>/dev/null; then
    exit 0
  fi
  trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

  pid=${2:-$(tmux display-message -p '#{client_pid}')}
  device="Mac"
  while [ "$pid" != "1" ] && [ -n "$pid" ]; do
    comm=$(ps -o comm= -p "$pid" 2>/dev/null | xargs)
    if [[ "$comm" == sshd* ]]; then
      device="iPad"
      break
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done

  # Update scroll bindings only when device changes
  prev=$(tmux show-option -gqv @active-device)
  if [ "$prev" != "$device" ]; then
    reverse=$([ "$device" = "iPad" ] && echo 1 || echo 0)
    "$0" apply "$reverse"
  fi
  tmux set -g @active-device "$device"
  exit 0
fi

if [ "$mode" = "toggle" ]; then
  current=$(tmux show-option -gqv @scroll-reversed)
  [ "$current" = "1" ] && reverse=0 || reverse=1
else
  reverse=${2:-0}
fi

# Apply all bindings atomically via source-file to prevent partial updates
# Updates root, copy-mode, AND copy-mode-vi tables to avoid stale conflicts
tmpfile=$(mktemp /tmp/tmux-scroll.XXXXXX)
cat > "$tmpfile" << 'CONF'
# WheelUp = scroll into history / entry direction
# Check pane_in_mode FIRST so copy mode takes priority over mouse_any_flag
bind-key -T root WheelUpPane if-shell -F "#{pane_in_mode}" {
  send-keys -X -N 3 scroll-up
} {
  if-shell -F "#{mouse_any_flag}" { send-keys -M } {
    if-shell -F "#{@scroll-cooldown}" {} { copy-mode }
  }
}
# WheelDown = scroll toward bottom / exit direction
bind-key -T root WheelDownPane if-shell -F "#{pane_in_mode}" {
  send-keys -X -N 3 scroll-down
  if-shell -F "#{==:#{scroll_position},0}" {
    send-keys -X cancel
    set -g @scroll-cooldown 1
    run-shell -b 'sleep 0.5 && tmux set -g @scroll-cooldown 0'
  }
} {
  if-shell -F "#{mouse_any_flag}" { send-keys -M }
}
unbind-key -T copy-mode-vi WheelUpPane
unbind-key -T copy-mode-vi WheelDownPane
unbind-key -T copy-mode WheelUpPane
unbind-key -T copy-mode WheelDownPane
set-hook -g pane-mode-changed[100] "refresh-client"
set -g @scroll-cooldown 0
set -g @scroll-reversed 0
CONF

# If reversed, swap wheel directions atomically
if [ "$reverse" = "1" ]; then
  sed -i '' \
    -e 's/WheelUpPane/__UP__/g' \
    -e 's/WheelDownPane/WheelUpPane/g' \
    -e 's/__UP__/WheelDownPane/g' \
    -e 's/@scroll-reversed 0/@scroll-reversed 1/' \
    "$tmpfile"
fi
tmux source-file "$tmpfile"
rm -f "$tmpfile"

label=$([ "$reverse" = 1 ] && echo Reversed || echo Normal)
if [ "$mode" = "toggle" ]; then
  tmux display "Scroll: $label"
fi
