function vreload
	vagrant destroy -f $argv[1]
vssh $argv[1]
end
