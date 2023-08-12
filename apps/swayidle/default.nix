{
  pkgs,
  config,
  lib,
  ...
}: let
  systemctlBin = "/run/current-system/sw/bin/systemctl";

  gtklock = "${pkgs.procps}/bin/pgrep gtklock || ${pkgs.util-linux}/bin/setsid --fork ${pkgs.gtklock}/bin/gtklock";
  # swaylock = "${pkgs.waylock}/bin/waylock";
  locker = gtklock;
in {
  imports = [
    ../swaylock
  ];

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
          timeout = 120;
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
