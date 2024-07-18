{
  config,
  npins,
  pkgs,
  ...
}:
{
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

  home.packages = [ pkgs.kitty.terminfo ];

  programs.kitty = {
    enable = true;
    extraConfig = ''
      include ${config.xdg.configHome}/kitty/theme-dark.conf
      include ${config.xdg.configHome}/kitty/dotfiles.conf
    '';

    settings =
      {
        font_family = config.dotfiles.gui.font.mono;
        allow_remote_control = "socket-only";
      }
      // (
        if pkgs.stdenv.isDarwin then
          {
            mouse_map = "cmd+left release grabbed,ungrabbed mouse_click_url";
            macos_option_as_alt = "both";

            font_size = "13";
            listen_on = "unix:\${TMPDIR}/dotkitty";
          }
        else
          {
            hide_window_decorations = "yes";
            font_size = "11";
            touch_scroll_multiplier = "20.0";
            kitty_mod = "ctrl+shift";

            allow_remote_control = "socket-only";
            listen_on = "unix:@dotkitty";
          }
      );

    shellIntegration.enableFishIntegration = false;
  };
}
