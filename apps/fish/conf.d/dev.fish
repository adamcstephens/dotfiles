if status is-interactive
    set -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
    set -x PYTHONSTARTUP ~/.dotfiles/apps/python/pythonstartup.py
end
