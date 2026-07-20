{ pkgs, ... }:
{
  packages = [ pkgs.bat ];

  xdg.config.files."bat/config".source = ./config;
}
