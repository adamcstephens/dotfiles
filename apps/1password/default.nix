{ lib, pkgs, ... }:
{
  systemd.user.services."1password" = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service.ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
  };
}
