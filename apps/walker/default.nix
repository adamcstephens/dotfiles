{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.walker;
in
{
  options.dotfiles.apps.walker = {
    enable = lib.mkEnableOption "walker launcher service";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.elephant
      pkgs.walker
    ];

    xdg.configFile."elephant/websearch.toml".source =
      dotlib.source "apps/walker/elephant/websearch.toml";

    xdg.configFile."walker/config.toml".source = dotlib.source "apps/walker/config.toml";

    xdg.configFile."walker/themes/dotfiles/style.css".text = with config.colorScheme.palette; ''
      @define-color window_bg_color #${base05};
      @define-color accent_bg_color #${base05};
      @define-color theme_fg_color #${base08};
    '';

    systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      elephant = {
        Unit.After = [ "graphical-session.target" ];
        Unit.PartOf = [ "graphical-session.target" ];
        Install.WantedBy = [ "graphical-session.target" ];

        Unit = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = lib.getExe pkgs.elephant;
          Restart = "on-failure";
          RestartSec = 1;

          # Clean up socket on stop
          ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/elephant.sock";
        };
      };

      walker = {
        Install.WantedBy = [ "graphical-session.target" ];
        Unit.PartOf = [ "graphical-session.target" ];
        Unit.Requires = [ "elephant.service" ];
        Unit.After = [
          "graphical-session.target"
          "elephant.service"
        ];

        Unit.X-Restart-Triggers = [
          config.xdg.configFile."walker/config.toml".source
          config.xdg.configFile."walker/themes/dotfiles/style.css".source
        ];

        Unit = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
          Restart = "on-failure";
        };
      };
    };
  };
}
