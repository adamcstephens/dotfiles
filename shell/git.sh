# shell: git
alias ga='git add'
function gac () {
  [ -z $1 ] && echo "needs argument" && return 20
  git add $1 && git commit -v
}
alias gbv='git branch -av'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
function glo () {
  [ -z $1 ] && git log --oneline -n 10 && return 0
  git log --oneline $@
}
alias gm='git merge'
alias gp='git push'
alias grh='git reset HEAD'
alias grv='git remote -v'
alias gs='git status' 
alias gss='git status --short' 
function gt () {
  [ -z $1 ] && git tag -l -n1 && return 0
  git tag $@
}
