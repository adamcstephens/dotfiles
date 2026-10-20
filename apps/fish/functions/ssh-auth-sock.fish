function find_ssh_agent
    set --local discovered_sock $SSH_AUTH_SOCK

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
        if string match --quiet $denied $SSH_AUTH_SOCK
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
        set DISCOVERED_SOCK (find_ssh_agent)
    end

    if ! test -e "$WELL_KNOWN_SOCK"
        ln -sf "$DISCOVERED_SOCK" "$WELL_KNOWN_SOCK"
    else if test "$WELL_KNOWN_SOCK" != "$DISCOVERED_SOCK" && test (readlink "$WELL_KNOWN_SOCK") != "$DISCOVERED_SOCK" && test -S "$DISCOVERED_SOCK"
        ln -sf "$DISCOVERED_SOCK" "$WELL_KNOWN_SOCK"
    end

    if ! test -e "$SIGNING_KEY_FILE" || test "$WELL_KNOWN_SOCK" -nt "$SIGNING_KEY_FILE"
        ssh-add -L | head --lines=1 >"$SIGNING_KEY_FILE"
    end

    set --export SSH_AUTH_SOCK "$WELL_KNOWN_SOCK"
end
