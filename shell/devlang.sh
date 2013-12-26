# plenv
if [ -d $HOME/.plenv/bin ]
then
  export PATH="$PATH:$HOME/.plenv/bin"
fi
if which plenv > /dev/null 2>&1; then eval "$(plenv init -)"; fi

# pyenv
if [ -d $HOME/.pyenv/shims ]
then
  export PATH="$PATH:$HOME/.pyenv/shims"
fi
if [ -d $HOME/.pyenv/bin ]
then
  export PATH="$PATH:$HOME/.pyenv/bin"
fi
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init -)"; fi

# rbenv
if [ -d $HOME/.rbenv/shims ]
then
  export PATH="$PATH:$HOME/.rbenv/shims"
fi
if [ -d $HOME/.rbenv/bin ]
then
  export PATH="$PATH:$HOME/.rbenv/bin"
fi
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init -)"; fi

function bootstrap_plenv {
  git clone git://github.com/tokuhirom/plenv.git ~/.plenv
  git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
}

function bootstrap_rbenv {
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
}
