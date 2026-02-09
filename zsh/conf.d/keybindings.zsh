# Vi mode
bindkey -v
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins "^F" forward-char
bindkey -M viins "^B" backward-char
bindkey -M viins "^D" delete-char-or-list
bindkey -M viins "^U" backward-kill-line
bindkey -M viins "^K" vi-kill-eol
bindkey -M viins "^N" down-line-or-history
bindkey -M viins "^P" up-line-or-history

# History fuzzy searching
zle -N history-fzy
bindkey '^r' history-fzy

function history-fzy() {
  BUFFER=$(history -n 1 | awk '!a[$0]++' | fzy --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle reset-prompt
}

# Quick jump
zle -N workdir
zle -N worktree

bindkey '^g' workdir
bindkey '^t' worktree

function workdir() {
  local result=""
  if [ $# -gt 1 ] && echo "Too many agruments" && return
  if [ $# -gt 0 ]; then
    result=$(fd --type directory . $1)
  else
    result=$(fd --type directory . $HOME/code)
  fi

  if [ -z "$result" ] && echo "No directory match query: $1" && return

  local selection=$(echo $result | fzy)
  if [ "$selection" ] && cd $selection && zle reset-prompt
}

function worktree() {
  local result=$(git worktree list)

  # validate fd command before pipe to fzy
  if [ -z "$result" ] && echo "No directory match query: $1" && return

  # validate fzy selection before next execution
  local selection=$(echo $result | fzy)
  if [ -z "$selection" ] && return

  # extracting path from fzy selection
  local target=$(echo $selection | awk '{print $1}')
  if [ "$target" ] && cd $target && zle reset-prompt
}
