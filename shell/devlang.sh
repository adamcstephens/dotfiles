# plenv
if [ -d $HOME/.plenv/bin ]
then
  export PATH="$HOME/.plenv/bin:$PATH"
fi
if which plenv > /dev/null 2>&1; then eval "$(plenv init -)"; fi

# pyenv
if [ -d $HOME/.pyenv/shims ]
then
  export PATH="$HOME/.pyenv/shims:$PATH"
fi
if [ -d $HOME/.pyenv/bin ]
then
  export PATH="$HOME/.pyenv/bin:$PATH"
fi
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init -)"; fi

# rbenv
if [ -d $HOME/.rbenv/shims ]
then
  export PATH="$HOME/.rbenv/shims:$PATH"
fi
if [ -d $HOME/.rbenv/bin ]
then
  export PATH="$HOME/.rbenv/bin:$PATH"
fi
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

if [[ -d $HOME/.local/bin ]]
then
  export PATH="$HOME/.local/bin:$PATH"
fi
