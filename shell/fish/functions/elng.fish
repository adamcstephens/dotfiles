function elng
	set filename (grep $argv[1] ~/notes/* | cut -f1 -d\: | sort -u)
vim $filename
end
