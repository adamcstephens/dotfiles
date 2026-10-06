{ dotlib, pkgs, ... }:
{
  xdg.config.files = {
    "pinnacle".source = dotlib.source "apps/pinnacle";

    # won't match the system version, but should be close enough
    "pinnacle/share".source = "${pkgs.pinnacle.lua-client-api}/share";
  };
}
