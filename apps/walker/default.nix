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
    home.packages = [
      pkgs.elephant
      pkgs.walker
    ];

    home.file.".config/elephant/websearch.toml".source =
      if config.dotfiles.nixosManaged then
        ./elephant/websearch.toml
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/walker/elephant/websearch.toml";

    home.file.".config/walker/config.toml".source =
      if config.dotfiles.nixosManaged then
        ./config.toml
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/walker/config.toml";

    home.file.".config/walker/themes/dotfiles/style.css".text = with config.colorScheme.palette; ''
      @define-color window_bg_color #${base05};
      @define-color accent_bg_color #${base05};
      @define-color theme_fg_color #${base08};
    '';

    systemd.user.services = {
      elephant = {
        Unit = {
          Description = "Elephant launcher backend";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
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

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      walker = {
        Unit = {
          Description = "Walker - Application Runner";
          ConditionEnvironment = "WAYLAND_DISPLAY";
          After = [
            "graphical-session.target"
            "elephant.service"
          ];
          Requires = [ "elephant.service" ];
          PartOf = [ "graphical-session.target" ];
          X-Restart-Triggers = [
            (builtins.hashString "sha256" (
              builtins.toJSON {
                config = config.home.file.".config/walker/config.toml".source;
                theme = config.home.file.".config/walker/themes/dotfiles/style.css".source;
              }
            ))
          ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
