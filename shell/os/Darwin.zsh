# brew installs
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ -d $(brew --prefix)/share/zsh-completions ]
then
  fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi
if [ -f /usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh ]
then
  source /usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh
fi
