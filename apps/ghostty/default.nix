{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fish.interactiveShellInit = lib.optionalString pkgs.stdenv.isDarwin ''
    fish_add_path --append --move ${config.home.homeDirectory}/Applications/Ghostty.app/Contents/MacOS
  '';

  xdg.configFile."ghostty/config".text =
    ''
      font-family = "${config.dotfiles.gui.font.mono}"
      background = #000000
      foreground = #ffffff
      selection-background = #7030af
      selection-foreground = #ffffff
      cursor-color = #ffffff
      cursor-text = #000000

      # normal
      palette = 0=#000000
      palette = 1=#ff5f59
      palette = 2=#44bc44
      palette = 3=#d0bc00
      palette = 4=#2fafff
      palette = 5=#feacd0
      palette = 6=#00d3d0
      palette = 7=#ffffff

      # bright
      palette = 8=#535353
      palette = 9=#ff5f5f
      palette = 10=#44df44
      palette = 11=#efef00
      palette = 12=#338fff
      palette = 13=#ff66ff
      palette = 14=#00eff0
      palette = 15=#989898

      copy-on-select = clipboard
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      gtk-single-instance = true
      window-decoration = false

      font-size = 11
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      macos-option-as-alt = true
      window-padding-x = 5
      window-padding-y = 5
    '';
}
