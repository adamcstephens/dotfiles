function gt
    if [ -z $argv[1] ]
        git tag --list -n1
    else
        git tag $argv
    end
end
