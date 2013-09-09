case $USER in
  'root')
    USERSTRING="%{$fg_bold[red]%}%n"
    ;;
  'adam')
    USERSTRING="%{$fg[green]%}"
    ;;
  *)
    USERSTRING="%{$fg[green]%}%n"
    ;;
esac

export PS1="${USERSTRING}@%m %{$fg[yellow]%}%~ %{$fg[cyan]%}❯%{$reset_color%} "

case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;@%m: %~\a"}
        ;;
esac
