{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  gtklockBin =
    if config.dotfiles.isNixos
    then "${self'.packages.gtklock}/bin/gtklock"
    else "/usr/bin/gtklock";
  systemctlBin =
    if config.dotfiles.isNixos
    then "${pkgs.systemdMinimal}/bin/systemctl"
    else "/usr/bin/systemctl";

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
      ++ (lib.optional (!config.dotfiles.isVM) [
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
