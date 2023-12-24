{ pkgs, inputs, ... }:
let
  package = inputs.sandbox.packages.${pkgs.system}.xautocfg;
in
{
  xdg.configFile."xautocfg.cfg".text = ''
    [keyboard]
    delay = 250
    rate = 80
  '';

  systemd.user.services.xautocfg = {
    Unit.PartOf = [ "xserver-session.target" ];
    Service = {
      ExecStart = "${package}/bin/xautocfg";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "xserver-session.target" ];
  };
}
