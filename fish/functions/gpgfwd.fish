function gpgfwd
    set host $argv[1]
    scp ~/.gnupg/pubring.kbx $host:.gnupg/
    scp ~/.gnupg/trustdb.gpg $host:.gnupg/
end
