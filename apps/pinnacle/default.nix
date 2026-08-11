{ config, pkgs, ... }:
{
  xdg.config.files = {
    "pinnacle".source =
      if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/pinnacle";

    # won't match the system version, but should be close enough
    "pinnacle/share".source = "${pkgs.pinnacle.lua-client-api}/share";
  };
}
