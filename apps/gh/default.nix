{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
let
  gh = pkgs.symlinkJoin {
    name = "gh-wrapped";
    paths = [ pkgs.gh ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/gh \
        --set GH_TELEMETRY false
    '';
  };
in
{
  config = lib.mkIf config.dotfiles.dev.enable {
    home.packages = [
      gh
    ];

    xdg.configFile = {
      "gh/config.yml" = {
        source = dotlib.source "apps/gh/config.yml";
        force = true;
      };
    };

    xdg.dataFile."gh/extensions/gh-stack/gh-stack".source = lib.getExe pkgs.gh-stack;
  };
}
