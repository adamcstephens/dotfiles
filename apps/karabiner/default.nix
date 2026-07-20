{ config, ... }:
{
  files.".config/karabiner".source = "${config.directory}/.dotfiles/apps/karabiner";
}
