{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.swayidle;
in
{
  options.dotfiles.apps.swayidle.enable = lib.mkEnableOption "swayidle";

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      systemdTarget = "wayland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe config.dotfiles.gui.wayland.locker}";
        }
        {
          event = "after-resume";
          command = "${lib.getExe pkgs.wlopm} --on *";
        }
      ];
      timeouts =
        [
          {
            timeout = 600;
            command = "${lib.getExe config.dotfiles.gui.wayland.locker}";
          }
          {
            timeout = 900;
            command = "${lib.getExe pkgs.wlopm} --off *";
          }
        ]
        ++ lib.optionals (!config.dotfiles.gui.dontSleep) [
          {
            timeout = 360;
            command = "/run/current-system/sw/bin/systemctl sleep";
          }
        ];
    };
  };
}
