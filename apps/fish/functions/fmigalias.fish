function fmigalias
    set -l myAlias $argv[1]
    rg -N "alias $myAlias=" ~/.shell_generic.sh | sed -e 's,\\\\\$,,g' | source -
    funcsave $myAlias
    fish_indent --write ~/.dotfiles/fish/functions/$myAlias.fish
end
