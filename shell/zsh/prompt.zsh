[ -e /etc/profile.d/cmm-env.sh ] && source /etc/profile.d/cmm-env.sh
case $APP_ENV in
  'production')
    ENVCOLOR='$fg_bold[red]'
    ;;
  'integration')
    ENVCOLOR='$fg[yellow]'
    ;;
  * )
    ENVCOLOR='$fg[green]'
    ;;
esac

case $USER in
  'root')
    USERSTRING="%{$fg_bold[red]%}%n"
    ;;
  'adam'|'astephens'|'adam.c.stephens')
    USERSTRING="%{${ENVCOLOR}%}${APP_ENV}"
    ;;
  *)
    USERSTRING="%{${ENVCOLOR}%}${APP_ENV}%n"
    ;;
esac

export PS1="${USERSTRING}@%m %{$fg[yellow]%}%2c %{$fg[cyan]%}❯%{$reset_color%} "

case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;@%m: %~\a"}
        ;;
esac
