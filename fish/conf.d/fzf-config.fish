if status is-interactive
    fzf_configure_bindings --directory=\ct
    set fzf_fd_opts --hidden --exclude=.git
end
