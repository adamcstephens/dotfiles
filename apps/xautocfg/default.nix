{self', ...}: {
  xdg.configFile."xautocfg.cfg".text = ''
    [keyboard]
    delay = 250
    rate = 80
  '';

  systemd.user.services.xautocfg = {
    Unit.BindsTo = ["xserver-session.target"];
    Service = {
      ExecStart = "${self'.packages.xautocfg}/bin/xautocfg";
      Restart = "on-failure";
    };
    Install.WantedBy = ["xserver-session.target"];
  };
}
