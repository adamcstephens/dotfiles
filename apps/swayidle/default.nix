{pkgs, ...}: let
  # ${self'.packages.gtklock}
  gtklock = "${pkgs.util-linux}/bin/setsid --fork /usr/bin/gtklock";
in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.procps}/bin/pgrep gtklock || ${gtklock}";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${gtklock}";
      }
      {
        timeout = 300;
        command = "sudo systemctl suspend";
      }
    ];
  };

  systemd.user.services.swayidle = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };
}
