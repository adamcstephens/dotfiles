function fmigalias
rg -N $argv[1]= ~/.shell_generic.sh | source -
funcsave $argv[1]
end
