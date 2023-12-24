{ config, ... }:
{
  home.file.".aspell.en.pws".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/aspell/aspell.en.pws";
}
