function gpmb
    set --local branchname (git rev-parse --abbrev-ref HEAD)
    git push mirrors $branchname:$branchname $argv
end
