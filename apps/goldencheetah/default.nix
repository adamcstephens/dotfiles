{ dotlib, pkgs, ... }:
{
  home.packages = [ pkgs.golden-cheetah ];

  smfh.xdg.config.files."goldencheetah.org".source = dotlib.source "apps/goldencheetah";
}
