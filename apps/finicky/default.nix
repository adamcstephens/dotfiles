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
  home.file.".finicky.js".source = dotlib.source "apps/finicky/finicky.js";
}
