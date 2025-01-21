{
  config,
  npins,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.tmuxinator ];

  xdg.configFile.tmuxinator.source =
    if config.dotfiles.nixosManaged then
      ./tmuxinator
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/tmux/tmuxinator";

  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile "${npins.vim-moonfly-colors}/extras/moonfly.tmux" + builtins.readFile ./tmux.conf;
  };
}
