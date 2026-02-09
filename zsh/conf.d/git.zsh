# Git functions
function try() {
  local DATE=$(TZ='UTC-7' date '+%Y-%m-%dT%H%M%S.000+0700')
  local NOTE="${1:-NO_NOTE}"

  git checkout -b "try/${DATE}+${NOTE}"
}

function delete-git-branches() {
  # Delete remote branches
  git branch -a | grep 'remotes/origin' | grep -v main \
  | sed 's|remotes/origin/||' \
  | xargs -r git push origin --delete 2>&1 \
  | sed \
    -e "s/error: unable to delete '\([^']*\)': remote ref does not exist/no remote \1/" \
    -e '/error: failed to push some refs/d'

  # Delete local branches
  git branch | grep -v main | xargs -r git branch -D

  echo 'Current branches:'
  git fetch --prune && git branch -a
}

# reset author for all commits in history
function reset-author () {
  git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
}

# rebase all local branches to target branch (main as default)
function rebase-all () {
  git branch | cut -c 3- | for branch in $(cat); do git rebase ${1:-main} $branch; done
}

# integrate git branches - fzy
function gco() {
  local branch="$1"

  if [ -n "$branch" ]; then
    git checkout "$branch"
  else
    local branch_to_checkout
    branch_to_checkout=$(git branch | fzy | awk '{print substr($0, 3)}')

    if [ -n "$branch_to_checkout" ]; then
      git checkout "$branch_to_checkout"
    else
      echo "No branch selected or found."
    fi
  fi
}

# integrate git cherry-pick
function gcp() {
  local branch="$1"

  if [ -n "$branch" ]; then
    git cherry-pick "$branch"
  else
    local branch_to_cherry_pick
    branch_to_cherry_pick=$(git branch | fzy | awk '{print substr($0, 3)}')

    if [ -n "$branch_to_cherry_pick" ]; then
      git cherry-pick "$branch_to_cherry_pick"
    else
      echo "No branch selected or found."
    fi
  fi
}

# GitHub CLI
alias ghas="gh auth status"
# alias ghds="gh auth switch --user dalk-hds"
alias glkda="gh auth switch --user 0xlkda"

alias git.conflicts='$(git diff --name-only --diff-filter=U)'
alias gist="gh gist"
alias ghc="gh repo clone"

# Git aliases
alias gs='git reset --soft $(git merge-base origin/main HEAD)'
alias gcb="git checkout -b"
alias gss="git show -s"
alias gst="git status -s"
alias gf="git fetch"
alias gd="git diff"
alias gds="git diff --staged"
alias gp="git pull"
alias gP="git push"
alias gPf="git push --force-with-lease"

alias gw="git worktree"
alias gb="git branch"
alias gc="git commit --verbose"
alias gcm="git commit --verbose --message"
alias gca="git commit --all --verbose"
alias gcam="git commit --amend --verbose"
alias gcam!="git commit --amend --no-edit"

alias ga="git add --verbose"
alias gaa="git add --all --verbose"
alias gac="git add --update --verbose"

alias gbd="git branch -d"
alias gbD="git branch -D"

alias gl='git log'
alias gl1='git log --oneline'
alias gla1='git log --oneline --all'
alias gla="git log --graph --all -15"
alias gls="git log --stat -n3"
alias glc="git log -p"
