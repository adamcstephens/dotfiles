{
  dotlib,
  flake,
  pkgs,
  ...
}:
{
  home.packages = [
    flake.packages.${pkgs.stdenv.hostPlatform.system}.finicky
  ];
  smfh.files.".finicky.js".source = dotlib.source "apps/finicky/finicky.js";
}
