ENVCOLOR='$fg[green]'
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
