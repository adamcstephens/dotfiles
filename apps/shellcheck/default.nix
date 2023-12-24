{ pkgs, ... }:
{
  home.packages = [ pkgs.shellcheck ];

  xdg.configFile.shellcheckrc.source = ./shellcheckrc;
}
