function find_ssh_agent
    set --local discovered_sock $SSH_AUTH_SOCK
    # Previous invocations export our symlink; inspect its target rather than the alias.
    if test "$discovered_sock" = "$argv[1]"
        set discovered_sock (readlink "$argv[1]")
    end

    function find_allowed_socket
        set --local allowlist
        if test -n "$XDG_RUNTIME_DIR"
            set --append allowlist "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock" "$XDG_RUNTIME_DIR/ssh-tpm-agent"
        end
        set --append allowlist "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

        for allowed in $allowlist
            if test -S $allowed
                echo $allowed
                return
            end
        end
    end

    set --local denylist '/var/run/com.apple.launchd.*/Listeners' '/tmp/tuios*/*.sock'
    for denied in $denylist
        if string match --quiet $denied "$discovered_sock"
            set discovered_sock (find_allowed_socket)
            break
        end
    end

    echo $discovered_sock
end

function ssh-auth-sock --on-event="fish_preexec"
    set --local SIGNING_KEY_FILE "$HOME/.ssh/signing-key.pub"
    set --local WELL_KNOWN_SOCK $HOME/.ssh/ssh-auth.sock
    set --local DISCOVERED_SOCK ""

    if [ ! -z "$XDG_RUNTIME_DIR" ]
        set WELL_KNOWN_SOCK $XDG_RUNTIME_DIR/ssh-auth.sock
    end

    if test -n "$TUIOS_SESSION"
        set DISCOVERED_SOCK (tuios ssh-agent-path)
    else
        set DISCOVERED_SOCK (find_ssh_agent "$WELL_KNOWN_SOCK")
    end

    if test -S "$DISCOVERED_SOCK"; and test (readlink "$WELL_KNOWN_SOCK") != "$DISCOVERED_SOCK"
        ln -sf "$DISCOVERED_SOCK" "$WELL_KNOWN_SOCK"
    end

    # ssh-add must query the selected agent, not the socket we just replaced.
    set --export SSH_AUTH_SOCK "$WELL_KNOWN_SOCK"

    # Keys can change without the socket changing. Preserve the file if the agent has no keys.
    set --local signing_keys (ssh-add -L)
    if test $status -eq 0; and test (count $signing_keys) -gt 0
        printf '%s\n' "$signing_keys[1]" >"$SIGNING_KEY_FILE"
    end
end
