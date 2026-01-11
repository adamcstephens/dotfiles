{ pkgs, ... }:
{
  home.packages = [ pkgs.btop ];

  xdg.configFile."btop/btop.conf".source = ./btop.conf;
}
