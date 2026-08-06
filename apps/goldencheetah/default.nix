{ config, pkgs, ... }:
{
  packages = [ pkgs.golden-cheetah ];

  files.".config/goldencheetah.org".source = "${config.directory}/.dotfiles/apps/goldencheetah";
}
