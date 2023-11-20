{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."kitty/theme-light.conf".source = ./theme-light.conf;

  home.packages = [
    pkgs.kitty.terminfo
  ];

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;

    settings = with config.colorScheme.colors;
      {
        active_border_color = "#${base03}";
        active_tab_background = "#${base00}";
        active_tab_foreground = "#${base05}";
        background = "#${base00}";
        cursor = "#${base05}";
        foreground = "#${base05}";
        inactive_border_color = "#${base01}";
        inactive_tab_background = "#${base01}";
        inactive_tab_foreground = "#${base04}";
        selection_background = "#${base05}";
        selection_foreground = "#${base00}";
        tab_bar_background = "#${base01}";
        url_color = "#${base04}";

        color0 = "#${base00}";
        color1 = "#${base08}";
        color2 = "#${base0B}";
        color3 = "#${base0A}";
        color4 = "#${base0D}";
        color5 = "#${base0E}";
        color6 = "#${base0C}";
        color7 = "#${base05}";
        color8 = "#${base03}";
        color9 = "#${base09}";
        color10 = "#${base0B}";
        color11 = "#${base0F}";
        color12 = "#${base0D}";
        color13 = "#${base0E}";
        color14 = "#${base0F}";
        color15 = "#${base07}";

        font_family = config.dotfiles.gui.font.mono;
        allow_remote_control = "socket-only";
      }
      // (
        if pkgs.stdenv.isDarwin
        then {
          mouse_map = "cmd+left release grabbed,ungrabbed mouse_click_url";
          macos_option_as_alt = "both";

          font_size = "13";
          listen_on = ''unix:''${TMPDIR}/kitty'';
        }
        else {
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
