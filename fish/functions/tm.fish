function tm
  pushd ~
    tmux attach-session || tmux new-session
  popd
end
