{
  inputs,
  lib,
  pkgs,
  ...
}: let
  kmonad = lib.getExe inputs.kmonad.packages.${pkgs.system}.kmonad;
in {
  systemd.user.services.kmonad = {
    Unit.PartOf = ["default.target"];
    Install.WantedBy = ["default.target"];

    Service.ExecStart = "${kmonad} --log-level warn ${./thinkpad.kbd}";
  };
}
