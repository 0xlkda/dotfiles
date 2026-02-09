#!/bin/sh

NVIM_SERVER="${NVIM_LISTEN_ADDRESS:-/tmp/nvim}"

match=$(tmux capture-pane -p \
  | grep -Eo "$(pwd | sed 's|/|\\/|g')/[^:[:space:]]+:[0-9]+" \
  | head -n1)

echo "${match}"

[ -z "$match" ] && echo "No file:line match found in pane" && exit 0

file=${match%:*}
line=${match##*:}

echo "+${line} ${file}"
