#!/bin/bash
# Usage: scroll-direction.sh detect [client_pid] | scroll-direction.sh toggle
mode=${1:-detect}

# Detect device by walking process tree for sshd
device="Mac"
pid=${2:-$(tmux display-message -p '#{client_pid}')}
while [ "$pid" != "1" ] && [ -n "$pid" ]; do
  comm=$(ps -o comm= -p "$pid" 2>/dev/null | xargs)
  if [[ "$comm" == sshd* ]]; then
    device="iPad"
    break
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done

if [ "$mode" = "toggle" ]; then
  current=$(tmux show-option -gqv @scroll-reversed)
  [ "$current" = "1" ] && reverse=0 || reverse=1
elif [ "$mode" = "apply" ]; then
  reverse=${2:-0}
else
  reverse=0
fi

if [ "$reverse" = "1" ]; then
  # Reversed: WheelDown enters copy mode, scroll directions swapped
  tmux bind-key -T root WheelUpPane \
    if-shell -F '#{||:#{pane_in_mode},#{mouse_any_flag}}' 'send-keys -M'
  tmux bind-key -T root WheelDownPane \
    if-shell -F '#{||:#{pane_in_mode},#{mouse_any_flag}}' 'send-keys -M' 'copy-mode -e'
  tmux bind-key -T copy-mode-vi WheelUpPane \
    select-pane '\;' send-keys -X -N 1 scroll-down
  tmux bind-key -T copy-mode-vi WheelDownPane \
    select-pane '\;' send-keys -X -N 1 scroll-up
  tmux set -g @scroll-reversed 1
else
  # Standard: WheelUp enters copy mode, normal scroll directions
  tmux bind-key -T root WheelUpPane \
    if-shell -F '#{||:#{pane_in_mode},#{mouse_any_flag}}' 'send-keys -M' 'copy-mode -e'
  tmux bind-key -T root WheelDownPane \
    if-shell -F '#{||:#{pane_in_mode},#{mouse_any_flag}}' 'send-keys -M'
  tmux bind-key -T copy-mode-vi WheelUpPane \
    select-pane '\;' send-keys -X -N 1 scroll-up
  tmux bind-key -T copy-mode-vi WheelDownPane \
    select-pane '\;' send-keys -X -N 1 scroll-down
  tmux set -g @scroll-reversed 0
fi

label=$([ "$reverse" = 1 ] && echo Reversed || echo Normal)
if [ "$mode" = "toggle" ]; then
  tmux display "Scroll: $label"
fi
