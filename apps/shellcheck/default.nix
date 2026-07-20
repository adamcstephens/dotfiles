{ pkgs, ... }:
{
  packages = [ pkgs.shellcheck ];

  xdg.config.files.shellcheckrc.source = ./shellcheckrc;
}
