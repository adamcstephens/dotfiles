{ pkgs, ... }:
{
  home.packages = [ pkgs.swayosd ];

  systemd.user = {
    services.swayosd = {
      Unit = {
        Description = "Volume/backlight OSD indicator";
        PartOf = [ "wayland-session.target" ];
        After = [ "wayland-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Documentation = "man:swayosd(1)";
        StartLimitBurst = 5;
        StartLimitIntervalSec = 10;
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        RestartSec = "2s";
      };

      Install = {
        WantedBy = [ "wayland-session.target" ];
      };
    };
  };
}
