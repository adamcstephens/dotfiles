{
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.kanata = {
    Unit.PartOf = ["default.target"];
    Install.WantedBy = ["default.target"];

    Service.ExecStart = "${lib.getExe pkgs.kanata} --cfg ${./thinkpad.kbd}";
  };
}
