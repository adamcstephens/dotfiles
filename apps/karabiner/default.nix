{ dotlib, ... }:
{
  xdg.configFile."karabiner".source = dotlib.source "apps/karabiner";
}
