{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.squeezelite;
in
{
  options.dotfiles.apps.squeezelite = {
    enable = lib.mkEnableOption "squeezelite service";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.squeezelite = {
      Unit = {
        Description = "X overlay bar";
        PartOf = [ cfg.systemdTarget ];
      };

      Install.WantedBy = [ cfg.systemdTarget ];

      Service = {
        ExecStart = "${lib.getExe pkgs.squeezelite-pulse}";
        StandardInput = "socket";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
