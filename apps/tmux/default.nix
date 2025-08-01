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

  xdg.configFile."tmux/theme-dark.conf".source = "${npins.vim-moonfly-colors}/extras/moonfly.tmux";
  xdg.configFile."tmux/smart-splits.tmux".source = "${npins."smart-splits.nvim"}/smart-splits.tmux";
}
