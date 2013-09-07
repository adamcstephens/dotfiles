function vssh
	if not vagrant status $argv[1] | grep 'running ('
vagrant up $argv[1]
end
vagrant ssh $argv[1]
end
