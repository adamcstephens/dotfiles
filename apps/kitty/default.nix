{
  config,
  npins,
  pkgs,
  ...
}:
{
  xdg.configFile."kitty/theme-dark.conf".source =
    npins."modus-themes.nvim" + "/extras/kitty/modus_vivendi.conf";
  xdg.configFile."kitty/theme-light.conf".source =
    npins."modus-themes.nvim" + "/extras/kitty/modus_operandi.conf";

  home.packages = [ pkgs.kitty.terminfo ];

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;

    settings =
      {
        include = npins."modus-themes.nvim" + "/extras/kitty/modus_vivendi.conf";
        font_family = config.dotfiles.gui.font.mono;
        allow_remote_control = "socket-only";
      }
      // (
        if pkgs.stdenv.isDarwin then
          {
            mouse_map = "cmd+left release grabbed,ungrabbed mouse_click_url";
            macos_option_as_alt = "both";

            font_size = "13";
            listen_on = "unix:\${TMPDIR}/kitty";
          }
        else
          {
            hide_window_decorations = "yes";
            font_size = "10.5";
            touch_scroll_multiplier = "20.0";
            kitty_mod = "ctrl+shift";

            allow_remote_control = "socket-only";
            listen_on = "unix:@kitty";
          }
      );

    shellIntegration.enableFishIntegration = false;
  };
}
