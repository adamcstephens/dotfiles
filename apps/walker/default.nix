{
  config,
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
    packages = [
      pkgs.elephant
      pkgs.walker
    ];

    xdg.config.files."elephant/websearch.toml".source =
      if config.dotfiles.nixosManaged then
        ./elephant/websearch.toml
      else
        "${config.directory}/.dotfiles/apps/walker/elephant/websearch.toml";

    xdg.config.files."walker/config.toml".source =
      if config.dotfiles.nixosManaged then
        ./config.toml
      else
        "${config.directory}/.dotfiles/apps/walker/config.toml";

    xdg.config.files."walker/themes/dotfiles/style.css".text = with config.colorScheme.palette; ''
      @define-color window_bg_color #${base05};
      @define-color accent_bg_color #${base05};
      @define-color theme_fg_color #${base08};
    '';

    systemd.services = {
      elephant = {
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];

        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe pkgs.elephant;
          Restart = "on-failure";
          RestartSec = 1;

          # Clean up socket on stop
          ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/elephant.sock";
        };
      };

      walker = {
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        requires = [ "elephant.service" ];
        after = [
          "graphical-session.target"
          "elephant.service"
        ];

        reloadTriggers = [
          (builtins.hashString "sha256" (
            builtins.toJSON {
              config = config.xdg.config.files."walker/config.toml".source;
              theme = config.xdg.config.files."walker/themes/dotfiles/style.css".source;
            }
          ))
        ];

        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
          Restart = "on-failure";
        };
      };
    };
  };
}
