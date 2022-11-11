{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  gtklockBin = "${self'.packages.gtklock}/bin/gtklock";
  systemctlBin = "${pkgs.systemdMinimal}/bin/systemctl";

  gtklock = "${pkgs.procps}/bin/pgrep gtklock || ${pkgs.util-linux}/bin/setsid --fork ${gtklockBin}";
in {
  services.swayidle = {
    enable = true;
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

  systemd.user.services.swayidle = {
    Install = {
      WantedBy = config.dotfiles.gui.wantedBy;
    };
  };
}
