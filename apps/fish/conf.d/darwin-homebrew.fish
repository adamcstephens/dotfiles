if test -x /opt/homebrew/bin/brew
    # eval (/opt/homebrew/bin/brew shellenv)
    # do this manually to avoid homebrew overriding nix
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    set --append -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    set --append -gx MANPATH /opt/homebrew/share/man $MANPATH
    set --append -gx INFOPATH /opt/homebrew/share/info $INFOPATH
end
