if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
    if [ (uname) = Darwin ]
        ssh-add --apple-use-keychain
    else
        echo "Emtpy ssh-agent"
    end
end
