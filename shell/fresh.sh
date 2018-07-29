# fresh
[[ -e ~/.fresh/build/shell.sh ]] && source ~/.fresh/build/shell.sh

# set up ruby libs
export RUBYLIB=~/.fresh/source/github/hub/lib

alias fesl="fresh ; esl"
alias fuesl="fresh update && fresh clean && vundle_update &> /dev/null && esl"
