#!/bin/bash
# Detect device from client pid and update scroll bindings when device changes
pid=${1:-$(tmux display-message -p '#{client_pid}')}
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
  ~/code/dotfiles/tmux/scroll-direction.sh apply "$reverse"
fi
tmux set -g @active-device "$device"
