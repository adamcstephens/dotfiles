# [fresh] ~/.dotfiles

## Installation

``` sh
rm -f ~/.bashrc ~/.bash_profile
FRESH_LOCAL_SOURCE=adamcstephens/dotfiles bash -c "$(curl -sL https://raw.githubusercontent.com/freshshell/fresh/master/install.sh)"
ssh -t $REMOTEHOST 'sudo yum -y install git zsh; rm -f ~/.bash_profile ~/.bashrc; FRESH_LOCAL_SOURCE=adamcstephens/dotfiles bash -c "$(curl -sL https://raw.githubusercontent.com/freshshell/fresh/master/install.sh)"'
```

My dotfiles are managed by [fresh].

[fresh]: https://github.com/freshshell/fresh
