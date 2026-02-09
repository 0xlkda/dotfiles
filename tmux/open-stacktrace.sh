#!/bin/sh

NVIM_SERVER="${NVIM_LISTEN_ADDRESS:-/tmp/nvim}"

match=$(tmux capture-pane -p \
  | grep -Eo "$(pwd | sed 's|/|\\/|g')/[^:[:space:]]+:[0-9]+" \
  | head -n1)

[ -z "$match" ] && echo "No file:line match found in pane" && exit 0

file=${match%:*}
line=${match##*:}

if ! vim --server "$NVIM_SERVER" --remote-send "<C-\\><C-N>:e ${file}<CR>${line}Gzzzx" 2>/dev/null; then
  echo "Remote nvim not found. Opening directly..."
  # vim +"$line" "$file"
fi
