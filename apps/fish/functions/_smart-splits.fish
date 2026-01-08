# work around smart-splits not clearing pane status
# we rarely use a neovim terminal anyway
function _smart-splits --on-event="fish_preexec"
    tmux set -p @pane-is-vim ''
end
