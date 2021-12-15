function delkey
    if [ (count $argv) = 0 ]
        echo "supply deletion key"
        return 2
    end

    for target in $argv
        set -l delip (grep "$target " ~/.ssh/known_hosts | awk '{print $1}' | cut -f 2 -d \, | uniq)
        # breakpoint
        [ -z $delip ] || ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$delip"
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$target"
    end
end
