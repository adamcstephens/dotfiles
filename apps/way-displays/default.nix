{pkgs, ...}: {
  home.packages = [
    pkgs.way-displays
  ];

  systemd.user.services.way-displays = {
    Unit = {
      Description = "way-displays";
      Documentation = ["man:way-displays(1)"];
    };

    Service = {
      ExecStart = "${pkgs.way-displays}/bin/way-displays";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
