if status is-interactive
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    end
end
