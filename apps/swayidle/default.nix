{
  pkgs,
  self',
  ...
}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "setsid --fork ${self'.packages.gtklock}/bin/gtklock";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "setsid --fork ${self'.packages.gtklock}/bin/gtklock";
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
