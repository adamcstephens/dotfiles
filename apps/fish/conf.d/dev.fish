# asdf
if status is-interactive
    if test -e ~/.asdf/asdf.fish
        source ~/.asdf/asdf.fish
    end

    set -x ASDF_PYTHON_DEFAULT_PACKAGES_FILE ~/.dotfiles/apps/python/python-packages
    set -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
    set -x PYTHONSTARTUP ~/.dotfiles/apps/python/pythonstartup.py
end
