{ pkgs, ... }:
{
  packages = [ pkgs.btop ];

  xdg.config.files."btop/btop.conf".source = ./btop.conf;
}
