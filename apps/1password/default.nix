{ lib, pkgs, ... }:
{
  systemd.user.services."1password" = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
    Unit.After = [
      "graphical-session.target"
      "waybar.service"
      "xwayland-satellite.service"
    ];
  };
}
