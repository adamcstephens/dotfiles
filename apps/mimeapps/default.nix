{ config, ... }:
{
  xdg.config.files."mimeapps.list".source =
    if config.dotfiles.nixosManaged then
      ./mimeapps.list
    else
      "${config.directory}/.dotfiles/apps/mimeapps/mimeapps.list";
}
