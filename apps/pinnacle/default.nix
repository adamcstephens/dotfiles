{ config, ... }:
{
  xdg.config.files."pinnacle".source =
    if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/pinnacle";
}
