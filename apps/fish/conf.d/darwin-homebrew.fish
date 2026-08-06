if test -x /opt/homebrew/bin/brew
    # eval (/opt/homebrew/bin/brew shellenv)
    # do this manually to avoid homebrew overriding nix
    set --global --export HOMEBREW_PREFIX /opt/homebrew
    set --global --export HOMEBREW_CELLAR /opt/homebrew/Cellar
    set --global --export HOMEBREW_REPOSITORY /opt/homebrew
    set --append --global --export PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    set --append --global --export MANPATH /opt/homebrew/share/man $MANPATH
    set --append --global --export INFOPATH /opt/homebrew/share/info $INFOPATH
end
