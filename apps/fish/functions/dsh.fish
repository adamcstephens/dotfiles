function dsh
    if [ (count $argv) -lt 1 ]
        echo "Must pass image/sha"
        return 1
    end

    set runimg $argv[1]
    if [ -z $argv[2] ]
        set runcmd /bin/bash
    else
        set runcmd $argv[2..-1]
    end

    if command -q podman
        set runner podman
    else
        set runner docker
    end

    eval $runner run -t -i --rm=true $runimg $runcmd
end
