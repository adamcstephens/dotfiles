{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.colors;
  slug = config.colorScheme.slug;

  wezterm = pkgs.writeScriptBin "wezterm" ''
    export XDG_DATA_DIRS="${pkgs.bibata-cursors}:$XDG_DATA_DIRS"
    export XCURSOR_THEME="Bibata-Original-Classic"

    ${pkgs.wezterm}/bin/wezterm $@
  '';
in {
  programs.wezterm = {
    enable = true;
    package = wezterm;

    colorSchemes = {
      "${slug}" = {
        ansi = [
          "#${colors.base00}" # black
          "#${colors.base08}" # red
          "#${colors.base0B}" # green
          "#${colors.base0A}" # yellow
          "#${colors.base0D}" # blue
          "#${colors.base0E}" # magenta
          "#${colors.base0C}" # cyan
          "#${colors.base05}" # white
        ];

        brights = [
          "#${colors.base03}" # black
          "#${colors.base09}" # red
          "#${colors.base0B}" # green
          "#${colors.base0F}" # yellow
          "#${colors.base0D}" # blue
          "#${colors.base0E}" # magenta
          "#${colors.base0F}" # cyan
          "#${colors.base07}" # white
        ];

        foreground = "#${colors.base05}";
        background = "#${colors.base00}";
        cursor_fg = "#${colors.base00}";
        cursor_bg = "#${colors.base05}";
        selection_fg = "#${colors.base00}";
        selection_bg = "#${colors.base05}";
      };
    };

    extraConfig = ''
      return {
        font = wezterm.font("JetBrainsMono Nerd Font"),
        font_size = 10.5,
        color_scheme = "${slug}",
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        window_close_confirmation = "NeverPrompt",
        xcursor_theme = 'Bibata-Original-Classic',
        set_environment_variables = {
          TERM = 'xterm-screen-256color',
        },
      }
    '';
  };
}
