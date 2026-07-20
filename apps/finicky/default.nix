{ config, ... }:
{
  files.".finicky.js".source = "${config.directory}/.dotfiles/apps/finicky/finicky.js";
}
