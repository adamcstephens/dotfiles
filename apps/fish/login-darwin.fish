if [ -e "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]
    set -x SSH_AUTH_SOCK "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
end
