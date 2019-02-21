if [ -d /usr/local/bin ]
then
  export PATH="/usr/local/bin:$PATH"
fi

if [ -d /usr/local/sbin ]
then
  export PATH="/usr/local/sbin:$PATH"
fi

alias pki="brew install "
alias pks="brew search "
alias pksh="brew info "
alias pku="brew update && brew upgrade"
alias pkr="brew remove "

alias flushdns='sudo killall -HUP mDNSResponder'

newpassgen() {
  for z in {1..10}
  do
    n=$(cat /usr/share/dict/words | wc -l)
    for x in {1..3}
    do
      y="$(cat -n /usr/share/dict/words | grep -w $(jot -r 1 1 $n) | cut -f2)"
      echo -n "$y "
      if [[ "$x" == '2' ]]
      then
        y="$(od -vAn -N1 -tu < /dev/urandom | head -n 1 | awk '{print $1}')"
        z="$(pwgen -0yA -r abcdefghijklmnopqrstuvwxyz 1 1)"
        echo -n "$y$z "
      fi
    done
    echo
  done
}
