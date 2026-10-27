{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.swayosd ];

  systemd.user = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    services.swayosd = {
      Install.WantedBy = [ "wayland-session.target" ];
      Unit.PartOf = [ "wayland-session.target" ];
      Unit.After = [ "wayland-session.target" ];

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        StartLimitBurst = 5;
        StartLimitIntervalSec = 10;
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        RestartSec = "2s";
      };
    };
  };
}
