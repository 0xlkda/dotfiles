# Prevent duplicate entries
typeset -U path
typeset -U fpath

# Path to your oh-my-zsh installation.
export ZSH="/Users/alex/.config/.oh-my-zsh"

# ZSH internal plugins.
plugins=(git
	 alias-finder
	 common-aliases
	 copydir
	 copyfile
	 docker
	 docker-compose
	 encode64
	 extract
	 jsontools
	 node
	 urltools
	)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Pure theme setup
FPATH="$HOME/Projects/opensources/zsh-pure-theme/:$FPATH"
autoload -U promptinit; promptinit
prompt pure

# iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# ZSH external plugins 
source /Users/alex/Projects/opensources/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/alex/Projects/opensources/zsh-autosuggestions/zsh-autosuggestions.zsh

# FZF bootstrap
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Lazydocker
alias lzd='lazydocker'

# Nodenv
eval "$(nodenv init -)"

# Postgres setup
export PATH="/usr/local/opt/libpq/bin:$PATH"

# Aliases
alias zshconfig="vim $HOME/.zshrc"
alias reload="source $HOME/.zshrc"
alias vimconfig="vim $HOME/.vimrc"
alias afl="alias-finder -l $1"
alias help="man"
alias man="tldr $1"

