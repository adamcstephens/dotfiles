{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."ghostty/config".text =
    ''
      font-family = "${config.dotfiles.gui.font.mono}"
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      gtk-single-instance = true
      window-decoration = false

      font-size = 11
    '';
}
