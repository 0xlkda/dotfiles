#!/usr/bin/env bash
set -euo pipefail

apply_theme() {
  local theme="$1"

  if [ "$theme" = "light" ]; then
    BG="#faf4ed"       SURFACE="#d9d6d4"
    OVERLAY="#eee8e1"  BASE="#e4e1df"
    HL="#ff22cc"     MUTED="#6e6a86"
    PINE="#3e8fb0"     GOLD="#ea9d34"
    ROSE="#d7827e"     LOVE="#eb6f92"
    FOAM="#56949f"
  else
    BG="#232136"       SURFACE="#2a273f"
    OVERLAY="#393552"  BASE="#44415a"
    HL="#ff22cc"     MUTED="#6e6a86"
    PINE="#3e8fb0"     GOLD="#ea9d34"
    ROSE="#ea9a97"     LOVE="#eb6f92"
    FOAM="#9ccfd8"
  fi

  tmux set -g status-style "bg=$BG,fg=default"
  tmux set -g status-left " #[fg=$GOLD][#S]: "
  tmux set -g status-right "#[fg=$MUTED]#{@active-device} "

  tmux set -g mode-style "bg=$GOLD,fg=$BG"
  tmux set -g message-style "fg=$OVERLAY,bg=$GOLD"

  tmux set -g pane-border-style "fg=$MUTED"
  tmux set -g pane-active-border-style "fg=$PINE"

  tmux set -g window-status-format "#[fg=$MUTED]#I:#W"
  tmux set -g window-status-current-format "#[fg=$HL]#I:#W"

  tmux set -g @theme "$theme"
} 

mode="${1:-dark}"

if [ "$mode" = "toggle" ]; then
  current=$(tmux show -gv @theme 2>/dev/null || echo "dark")
  if [ "$current" = "dark" ]; then
    mode="light"
  else
    mode="dark"
  fi
fi

apply_theme "$mode"

# Notify nvim instances
for pane_info in $(tmux list-panes -a -F '#{pane_id}:#{pane_current_command}'); do
  pane_id="${pane_info%%:*}"
  pane_cmd="${pane_info##*:}"
  if [ "$pane_cmd" = "nvim" ] || [ "$pane_cmd" = "vim" ]; then
    sock="/tmp/nvim-tmux-${pane_id//%/}"
    if [ -S "$sock" ]; then
      nvim --server "$sock" --remote-send "<Cmd>lua SyncTheme()<CR>" 2>/dev/null &
    fi
  fi
done
wait

tmux display "Theme: $mode"
