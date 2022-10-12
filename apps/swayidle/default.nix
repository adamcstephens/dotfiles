{pkgs, ...}: let
  # ${self'.packages.gtklock}
  gtklockBin = "/usr/bin/gtklock";
  # ${pkgs.systemdMinimal}/bin/systemctl
  systemctlBin = "/usr/bin/systemctl";

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
    timeouts = [
      {
        timeout = 120;
        command = "${gtklock}";
      }
      {
        timeout = 360;
        command = "${systemctlBin} suspend";
      }
    ];
  };

  systemd.user.services.swayidle = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };
}
