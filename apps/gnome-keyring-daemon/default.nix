{...}: {
  systemd.user.services.gnome-keyring-daemon = {
    Unit = {
      Description = "gnome-keyring-daemon";
      Documentation = ["man:gnome-keyring-daemon(1)"];
      PartOf = ["default.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/wrappers/bin/gnome-keyring-daemon --replace --foreground";
      ExecReload = "/run/wrappers/bin/gnome-keyring-daemon --replace --foreground";
      RestartSec = 3;
      Restart = "on-abort";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
