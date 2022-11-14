{
  pkgs,
  config,
  lib,
  ...
}: let
  gtklockBin = "${pkgs.gtklock}/bin/gtklock";
  systemctlBin = "/run/current-system/sw/bin/systemctl";

  gtklock = "${pkgs.procps}/bin/pgrep gtklock || ${pkgs.util-linux}/bin/setsid --fork ${gtklockBin}";
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${gtklock}";
      }
    ];
    timeouts =
      [
        {
          timeout = 120;
          command = "${gtklock}";
        }
      ]
      ++ (lib.optionals (!config.dotfiles.isVM) [
        {
          timeout = 360;
          command = "${systemctlBin} suspend";
        }
      ]);
  };
}
