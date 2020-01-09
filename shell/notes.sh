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
alias nn="vim ~/notes/\`date +%Y-%m-%d_%H%M\`.md"
function nnn {
  vim ~/notes/$1.md
}
alias lnn="ls -lt ~/notes"
alias lln="ls -1 ~/notes/\`ls -1t ~/notes | head -n1\`"

function ewr {
  # create a monthly work report file with daily timestamps
  filename="${HOME}/notes/workreport-$(date +%Y.%m).md"
  datestamp="$(date +%Y.%m.%d)"
  if [ ! -f $filename ]
  then
    echo "# $(date +'%B %Y')" > $filename
    echo >> $filename
  fi
  if ! grep $datestamp $filename &>/dev/null
  then
    echo "## $datestamp" >> $filename
  fi
  vim $filename
}
