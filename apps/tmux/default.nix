{
  config,
  npins,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.tmux
  ];

  xdg.configFile."tmux/tmux.conf".source =
    if config.dotfiles.nixosManaged then
      ./tmux.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/tmux/tmux.conf";

  xdg.configFile."tmux/theme-dark.tmux".source = pkgs.runCommand "theme-dark.tmux" { } ''
    cat ${npins.vim-moonfly-colors}/extras/moonfly.tmux > $out
    cat << EOF >> $out
    set-option -g window-status-last-style fg=default,bg=default
    EOF
  '';

  xdg.configFile."tmux/theme-light.tmux".source = pkgs.runCommand "theme-light.tmux" { } ''
    cat ${npins."modus-themes.nvim"}"/extras/tmux/modus_operandi.tmux" > $out
    cat << EOF >> $out
    set-option -g pane-border-style 'fg=#9f9f9f,bg=default'
    set-option -g pane-active-border-style 'fg=#003497,bg=default'
    set-option -g window-status-last-style 'fg=#0a0a0a,bg=#c8c8c8'
    EOF
  '';

  xdg.configFile."tmux/smart-splits.tmux".source = "${npins."smart-splits.nvim"}/smart-splits.tmux";

  xdg.configFile."tmux/tmux-click-copy".source = npins."tmux-click-copy";
}
