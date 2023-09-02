{
  pkgs,
  config,
  lib,
  ...
}: let
  systemctlBin = "/run/current-system/sw/bin/systemctl";
  colors = config.colorScheme.colors;

  # gtklock = "${pkgs.procps}/bin/pgrep gtklock || ${pkgs.util-linux}/bin/setsid --fork ${pkgs.gtklock}/bin/gtklock";
  # swaylock = "${pkgs.waylock}/bin/waylock";
  waylock = "${lib.getExe pkgs.waylock} -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}";

  locker = waylock;
in {
  # imports = [
  #   ../swaylock
  # ];

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
        lib.optional (!config.dotfiles.gui.dontSuspend) {
          timeout = 360;
          command = "${systemctlBin} suspend";
        }
      );
  };
}
