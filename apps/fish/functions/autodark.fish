function autodark --on-event="fish_prompt"
    if test -f ~/.dotfiles/.dark-mode.state
        set dark_state (cat ~/.dotfiles/.dark-mode.state)
    else
        set dark_state true
    end

    if test -n "$auto_dark_mode" && test $auto_dark_mode = $dark_state
        return 0
    end

    if test $dark_state = true
        source ~/.config/fish/theme-dark.fish
    else
        source ~/.config/fish/theme-light.fish
    end

    set -g auto_dark_mode $dark_state
end
