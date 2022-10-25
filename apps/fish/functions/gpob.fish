function gpob
  set --local branchname (git rev-parse --abbrev-ref HEAD)
  git push -u origin $branchname:$branchname $argv;
end
