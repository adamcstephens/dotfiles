if [[ $USER == 'root' ]]
then
  USERSTRING="%{$fg_bold[red]%}%n"
elif [[ $USER == 'adam' ]]
then
  USERSTRING="%{$fg[green]%}"
else
  USERSTRING="%{$fg[green]%}%n"
fi

export PS1="${USERSTRING}@%m %{$fg[yellow]%}%~ %{$fg[cyan]%}❯%{$reset_color%} "
