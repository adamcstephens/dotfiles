{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.kitty.terminfo ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".text =
    ''
      include ${config.xdg.configHome}/kitty/theme-dark.conf
      include ${config.xdg.configHome}/kitty/dotfiles.conf

      allow_remote_control socket-only
      font_family ${config.dotfiles.gui.font.mono}
      shell_integration no-rc
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      font_size 13
      listen_on unix:''${TMPDIR}/kitty
      macos_option_as_alt both
      mouse_map cmd+left release grabbed,ungrabbed mouse_click_url
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      font_size 11
      hide_window_decorations yes
      kitty_mod ctrl+shift
      listen_on unix:@kitty
      touch_scroll_multiplier 20.0
    '';

  xdg.configFile."kitty/dotfiles.conf".source =
    if config.dotfiles.nixosManaged then
      ./dotfiles.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/kitty/dotfiles.conf";

  # themes
  xdg.configFile."kitty/theme-dark.conf".source = ./theme-dark.conf;
  xdg.configFile."kitty/theme-light.conf".source =
    npins."modus-themes.nvim" + "/extras/kitty/modus_operandi.conf";

  # smart-splits.nvim
  xdg.configFile."kitty/neighboring_window.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/neighboring_window.py";
  xdg.configFile."kitty/relative_resize.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/relative_resize.py";
  xdg.configFile."kitty/split_window.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/split_window.py";
}
