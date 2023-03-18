{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.colors;
  slug = config.colorScheme.slug;

  package = pkgs.wezterm;
  # package = pkgs.wezterm.overrideAttrs (old: rec {
  #   version = "20221206";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "wez";
  #     repo = "wezterm";
  #     rev = "92e851d648a0ebba5a855fcc59f7e30bb69d0ea0";
  #     hash = "sha256-SuqmPcDPSdO2hqZwxLmH3tYHYPqYyyiT/4gQMGx6554=";
  #     fetchSubmodules = true;
  #   };
  #   cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
  #     name = "${old.pname}-vendor.tar.gz";
  #     inherit src;
  #     outputHash = "sha256-eVA/iObrGgQomxuUSF1tUIFuNWq1rqYvVFyelX4VFKc=";
  #   });
  # });
in {
  programs.wezterm = {
    enable = true;
    package = package;

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
        font = wezterm.font("${config.dotfiles.gui.font}"),
        font_size = 10.5,
        color_scheme = "${slug}",
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        window_close_confirmation = "NeverPrompt",
        xcursor_theme = '${config.home.pointerCursor.name}',
        set_environment_variables = {
          TERM = 'xterm-screen-256color',
        },
      }
    '';
  };
}
