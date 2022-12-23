if status is-interactive
    fzf_configure_bindings --directory=\ct
    set fzf_fd_opts --hidden --exclude=.git

    set -x FZF_CTRL_T_COMMAND 'fd --type f --exclude .git --exclude vendor'
end
