{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.colorScheme.colors;
  slug = config.colorScheme.slug;

  weztermPackage = pkgs.wezterm.overrideAttrs (old: {
    version = "20221206";
    src = pkgs.fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "92e851d648a0ebba5a855fcc59f7e30bb69d0ea0";
      hash = "sha256-0YQAQ5NfUgmyNmxE2DmnPUB/LkvhMtS3N1IHTmuTgv4=";
      fetchSubmodules = true;
    };
    cargoSha256 = "0000000000000000000000000000000000000000000000000000";
  });

  wrapper = pkgs.writeScriptBin " wezterm" ''
    ${pkgs.makeWrapper}/bin/wrapProgram ${weztermPackage}/bin/wezterm --set XDG_DATA_DIRS "${pkgs.bibata-cursors}:$XDG_DATA_DIRS" --set XCURSOR_THEME "Bibata-Original-Classic"
  '';

  wezterm = pkgs.symlinkJoin {
    name = "wezterm-wrapped";
    paths = [weztermPackage wrapper];
  };
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
