{ dotlib, ... }:
{
  home.file.".finicky.js".source = dotlib.source "apps/finicky/finicky.js";
}
