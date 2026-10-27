{ dotlib, ... }:
{
  xdg.configFile."mimeapps.list".source = dotlib.source "apps/mimeapps/mimeapps.list";
}
