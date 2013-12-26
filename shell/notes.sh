# notes
alias cln="cat ~/notes/\`ls -1t ~/notes | head -n1\`"

#function aln {
#  fc -l $1 $1 >> 
#}
alias eln="vim ~/notes/\`ls -1t ~/notes | head -n1\`"
function elng {
  filename=`grep -H "$1" ~/notes/* | cut -f1 -d\: | sort -u | head -n1`
  if [ -e $filename ]
  then
    vim $filename
  else
    echo "no note found"
  fi
}
alias nn="vim ~/notes/\`date +%Y-%m-%d_%H%M\`.txt"
function nnn {
  vim ~/notes/$1.txt
}
alias lnn="ls -lt ~/notes"
alias lln="ls -1 ~/notes/\`ls -1t ~/notes | head -n1\`"

