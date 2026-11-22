{ dotlib, ... }:
{
  smfh.xdg.config.files."mimeapps.list".source = dotlib.source "apps/mimeapps/mimeapps.list";
}
