# Prevent duplicate entries
typeset -U path
typeset -U fpath

# ZPLUG setup
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

# Default PATH
export PATH="/usr/local/sbin:$PATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Lazydocker
alias lzd='lazydocker'

# Nodenv
eval "$(nodenv init -)"

# Postgres setup
export PATH="/usr/local/opt/libpq/bin:$PATH"

# FZF bootstrap
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Aliases
alias vim='nvim'
alias me="cd ~/Projects"
alias work="cd ~/Noggin"
alias zshconfig="vim $HOME/.zshrc"
alias reload="source $HOME/.zshrc"
alias vimconfig="vim $HOME/.vimrc"
alias afl="alias-finder -l $1"
alias help="man"
alias man="tldr $1"
