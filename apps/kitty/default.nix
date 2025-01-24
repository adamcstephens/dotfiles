{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  prj =
    if (config.dotfiles.nixosManaged || pkgs.stdenv.isDarwin) then
      pkgs.callPackage ../../packages/prj.nix { } |> lib.getExe
    else
      "${config.home.homeDirectory}/.dotfiles/bin/prj";
in
{
  home.packages = [ pkgs.kitty.terminfo ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".text =
    ''
      include ${npins.vim-moonfly-colors}/extras/moonfly-kitty.conf
      include ${config.xdg.configHome}/kitty/dotfiles.conf

      allow_remote_control socket-only
      font_family ${config.dotfiles.gui.font.mono}
      map ctrl+shift+p launch --type=overlay-main ${prj}
      map super+shift+p launch --type=overlay-main ${prj} --remote
      shell_integration no-rc

    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      font_size 13
      listen_on unix:''${TMPDIR}/kitty
      macos_option_as_alt both
      macos_show_window_title_in window
      mouse_map cmd+left release grabbed,ungrabbed mouse_click_url
      confirm_os_window_close 1
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      font_size 10
      hide_window_decorations yes
      kitty_mod ctrl+shift
      listen_on unix:@kitty
      touch_scroll_multiplier 20.0
      confirm_os_window_close 0
    '';

  xdg.configFile."kitty/dotfiles.conf".source =
    if config.dotfiles.nixosManaged then
      ./dotfiles.conf
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/kitty/dotfiles.conf";

  # themes
  xdg.configFile."kitty/theme-dark.conf".source =
    npins.vim-moonfly-colors + "/extras/moonfly-kitty.conf";
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
