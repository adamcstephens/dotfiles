{ config, pkgs, ... }:
{
  xdg.config.files = {
    "pinnacle".source = config.dotfiles.source "apps/pinnacle";

    # won't match the system version, but should be close enough
    "pinnacle/share".source = "${pkgs.pinnacle.lua-client-api}/share";
  };
}
