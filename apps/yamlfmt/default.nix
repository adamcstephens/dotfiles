{ pkgs, ... }:
{
  home.packages = [ pkgs.yamlfmt ];
  xdg.configFile."yamlfmt/yamlfmt.yaml".text = ''
    formatter:
      type: basic
      retain_line_breaks_single: true
  '';
}
