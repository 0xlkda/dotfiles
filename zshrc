export PATH="/usr/local/sbin:$PATH"
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

# Prevent duplicate entries
typeset -U path
typeset -U fpath

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# FZF bootstrap
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Lazydocker
alias lzd='lazydocker'

# Nodenv
eval "$(nodenv init -)"

# Postgres setup
export PATH="/usr/local/opt/libpq/bin:$PATH"

# FZF and ripgrep config
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Aliases
alias zshconfig="vim $HOME/.zshrc"
alias reload="source $HOME/.zshrc"
alias vimconfig="vim $HOME/.vimrc"
alias afl="alias-finder -l $1"
alias help="man"
alias man="tldr $1"
