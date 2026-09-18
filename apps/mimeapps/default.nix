{ config, ... }:
{
  xdg.config.files."mimeapps.list".source = config.dotfiles.source "apps/mimeapps/mimeapps.list";
}
