{pkgs, ...}: {
  systemd.user.services.solaar = {
    Unit.PartOf = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];

    Service.ExecStart = "${pkgs.solaar}/bin/solaar-cli --window hide";
  };
}
