{ pkgs, ... }:
{
  packages = [ pkgs.swayosd ];

  systemd = {
    services.swayosd = {
      wantedBy = [ "wayland-session.target" ];
      partOf = [ "wayland-session.target" ];
      after = [ "wayland-session.target" ];

      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        StartLimitBurst = 5;
        StartLimitIntervalSec = 10;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        RestartSec = "2s";
      };
    };
  };
}
