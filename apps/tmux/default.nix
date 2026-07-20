{
  config,
  npins,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.tmux
  ];

  xdg.config.files."tmux/tmux.conf".source =
    if config.dotfiles.nixosManaged then
      ./tmux.conf
    else
      "${config.directory}/.dotfiles/apps/tmux/tmux.conf";

  xdg.config.files."tmux/theme-dark.tmux".source = pkgs.runCommand "theme-dark.tmux" { } ''
    cat ${npins.vim-moonfly-colors}/extras/moonfly.tmux > $out
    cat << EOF >> $out
    set-option -g window-status-last-style fg=default,bg=default
    EOF
  '';

  xdg.config.files."tmux/theme-light.tmux".source = pkgs.runCommand "theme-light.tmux" { } ''
    cat ${npins."modus-themes.nvim"}"/extras/tmux/modus_operandi.tmux" > $out
    cat << EOF >> $out
    set-option -g pane-border-style 'fg=#9f9f9f,bg=default'
    set-option -g pane-active-border-style 'fg=#003497,bg=default'
    set-option -g window-status-last-style 'fg=#0a0a0a,bg=#c8c8c8'
    EOF
  '';

  xdg.config.files."tmux/smart-splits.tmux".source = "${npins."smart-splits.nvim"}/smart-splits.tmux";

  xdg.config.files."tmux/tmux-click-copy".source = npins."tmux-click-copy";
}
