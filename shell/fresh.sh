# fresh
[[ -e ~/.fresh/build/shell.sh ]] && source ~/.fresh/build/shell.sh

alias fesl="fresh ; esl"
alias fuesl="fresh update && fresh clean && vundle_update &> /dev/null && esl"
