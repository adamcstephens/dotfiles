{ config, ... }:
{
  files.".aspell.en.pws".source = "${config.directory}/.dotfiles/aspell/aspell.en.pws";
}
