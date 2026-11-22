{
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  smfh.xdg.config.files = lib.mapAttrs' (
    name: _:
    lib.nameValuePair "pinnacle/${name}" {
      source = dotlib.source "apps/pinnacle/${name}";
    }
  ) (builtins.readDir ./.);

  # won't match the system version, but should be close enough
  xdg.configFile."pinnacle/share".source = "${pkgs.pinnacle.lua-client-api}/share";
}
