function ap --wraps='ansible-playbook ' --description 'alias ap=ansible-playbook '
    if command -q systemd-inhibit
        set inhibit systemd-inhibit
    end
    $inhibit ansible-playbook $argv
end
