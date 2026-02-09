#!/bin/sh
buf=$(cat)

# macOS system clipboard
if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$buf" | pbcopy
fi

# tmux paste buffer
tmux set-buffer -w -- "$buf"

# OSC52 to every connected client's tty
b64=$(printf '%s' "$buf" | base64 | tr -d '\r\n')
for tty in $(tmux list-clients -F '#{client_tty}'); do
    printf '\033]52;c;%s\a' "$b64" > "$tty"
done
