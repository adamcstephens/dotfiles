{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.ghostty
    pkgs.ghostty.shell_integration
  ];

  programs.fish.interactiveShellInit = lib.optionalString pkgs.stdenv.isDarwin ''
    if test -d "${config.home.homeDirectory}/Applications/Ghostty.app"
      fish_add_path --append --move "${config.home.homeDirectory}/Applications/Ghostty.app/Contents/MacOS"
      set --prepend fish_complete_path "${config.home.homeDirectory}/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d"
    else if test -d "/Applications/Ghostty.app"
      fish_add_path --append --move /Applications/Ghostty.app/Contents/MacOS
      set --prepend fish_complete_path "/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d"
    end

    if test -n "$GHOSTTY_RESOURCES_DIR"
      source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
    end
  '';

  xdg.configFile."ghostty/config".text = ''
    font-family = "${config.dotfiles.gui.font.mono}"
    config-file = dotfiles.conf
  ''
  + lib.optionalString pkgs.stdenv.isLinux ''
    config-file = linux.conf
  ''
  + lib.optionalString pkgs.stdenv.isDarwin ''
    config-file = mac.conf
  '';

  xdg.configFile."ghostty/dotfiles.conf".source =
    if config.dotfiles.nixosManaged then
      ./dotfiles.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ghostty/dotfiles.conf";

  xdg.configFile."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.isLinux {
    source =
      if config.dotfiles.nixosManaged then
        ./linux.conf
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ghostty/linux.conf";
  };

  xdg.configFile."ghostty/gtk-custom.css" = lib.mkIf pkgs.stdenv.isLinux {
    source =
      if config.dotfiles.nixosManaged then
        ./gtk-custom.css
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ghostty/gtk-custom.css";
  };

  xdg.configFile."ghostty/mac.conf" = lib.mkIf pkgs.stdenv.isDarwin {
    source =
      if config.dotfiles.nixosManaged then
        ./mac.conf
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ghostty/mac.conf";
  };
}
