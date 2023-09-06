{
  pkgs,
  config,
  lib,
  ...
}: let
  systemctlBin = "/run/current-system/sw/bin/systemctl";
  colors = config.colorScheme.colors;

  waylock = "${lib.getExe pkgs.waylock} -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}";
  locker = waylock;
in {
  config = lib.mkIf config.dotfiles.gui.wayland {
    services.swayidle = {
      enable = true;
      systemdTarget = "wayland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${locker}";
        }
      ];
      timeouts =
        [
          {
            timeout = 600;
            command = "${locker}";
          }
        ]
        ++ (
          lib.optional (!config.dotfiles.gui.dontSuspend)
          {
            timeout = 360;
            command = "${systemctlBin} suspend";
          }
        );
    };
  };
}
