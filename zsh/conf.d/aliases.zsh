# Environments
CONFIG="~/code/dotfiles"
USE_NIX="ln -s $CONFIG/environments/direnv .envrc | direnv allow ."
USE_NODE="ln -s $CONFIG/environments/node/shell.nix shell.nix"
USE_ESLINT="ln $CONFIG/environments/node/eslintrc-with-style .eslintrc"
alias newnode="$USE_NIX | $USE_NODE | $USE_ESLINT"
alias nn=newnode
alias nd="nix develop --command $SHELL"

# Basic
alias lns="ln -rs"
alias free="top -l 1 -s 0 | grep PhysMem | sed \"s/, /\n         /g\""
alias code="cd $HOME/code"
alias note="cd $HOME/Documents/notes"
alias vim="$HOME/.nix-profile/bin/nvim"
alias svim="sudo vim"
alias vi=vim
alias edit=vim
alias vl="vim -c \"normal '0\" -c \"bn\" -c \"bd\""
alias pc="pbcopy <"

# Tree
tree() { command tree --gitignore -L "${1:-3}" "${@:2}"; }
alias treeI="command tree -I"

# Config Dotfiles
alias reload="source ~/.zshrc && source ~/.zshenv"
alias rl=reload
alias zc="vim ~/.zshrc"
alias zac="vim ~/code/dotfiles/zsh/conf.d/aliases.zsh"
alias vc="vim ~/.config/nvim/init.lua"
alias tc="vim ~/.config/tmux/tmux.conf"

# C
alias mk=make
alias mkr="make run"
alias mkb="make build"
alias mkc="make clean"

# Tunneling Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Python3
alias py=python3
alias pip=pip3

# JavaScript & NodeJS
alias vp="vim package.json"
alias na="npm add"
alias ni="npm install"
alias nid="npm install -D"
alias nr="npm run"
alias nrs="npm run start"
alias nrd="npm run start:dev"

# NestJS
alias ng="nest generate"
alias ngm="nest generate module"
alias ngc="nest generate controller"
alias ngs="nest generate service"
alias ngr="nest generate resource"
alias ngpr="nest generate provider"

# Starship prompt
alias ss="starship"
alias ssc="starship config"

# Search using rg
# rg Foo       # Case sensitive search
# rg -i foo    # Case insensitive search
# rg -v foo    # Invert search, show all lines that don"t match pattern
# rg -l foo    # List only the files that match, not content
# rg -t md foo # Match by `md` file extension
alias search="rg"
alias s="search"

# Net
alias header="curl -I"

# Tmux
alias tks="tmux kill-server"
alias tn="tmuxinator n"
alias to="tmuxinator o"
alias ts="tmuxinator s"

# Listing
alias ls="ls --color --group-directories-first"
alias la="ls -la --color"
alias ll="ls -lh --color"
alias cpwd="pwd | tr -d \"\n\" | pbcopy && echo \"pwd copied to clipboard\""
alias mkdir="mkdir -pv"

# Shopify
alias theme="shopify theme"

# Video downloader
alias vd=yt-dlp

# Nginx
alias nginx="nginx -p ~/nginx"
alias nginx.test='nginx -t'
alias nginx.start='nginx'
alias nginx.stop='nginx -s stop'
alias nginx.reload='nginx -s reload'
alias nginx.config='vim ~/nginx/conf/nginx.conf'
alias nginx.restart='nginx.stop && nginx.start'
alias nginx.debug='tail -250f ~/nginx/logs/debug.log'
alias nginx.error='tail -250f ~/nginx/logs/error.log'
alias nginx.access='tail -250f ~/nginx/logs/access.log'
alias nginx.logs.default-ssl.access='tail -250f ~/nginx/logs/nginx.default.ssl.log'

# Docker
alias docker.file="vim Dockerfile"

docker.build() {
    docker build . -t "$PROJECT" "$@"
}

docker.run() {
    docker rm "$PROJECT"
    docker run --name "$PROJECT" --env-file .env "$@" "$PROJECT"
}

docker.up() {
    docker compose up
}
