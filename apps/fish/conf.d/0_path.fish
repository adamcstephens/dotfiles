if status is-interactive && ! command -q nix
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    else if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
        fenv source $HOME/.nix-profile/etc/profile.d/nix.sh
    end
end

# paths
fish_add_path --prepend --move ~/bin
fish_add_path --prepend --move ~/.dotfiles/bin

if test -e ~/.nix-profile/share/fish/vendor_completions.d
    set --prepend --export fish_complete_path ~/.nix-profile/share/fish/vendor_completions.d
end

if test -e ~/.nix-profile/share/fish/vendor_functions.d
    set --prepend --export fish_function_path ~/.nix-profile/share/fish/vendor_functions.d
end

if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
end

set -x XDG_DATA_DIRS "$HOME/.nix-profile/share/:$XDG_DATA_DIRS"

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
