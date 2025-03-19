{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.swayidle;
in
{
  options.dotfiles.apps.swayidle.enable = lib.mkEnableOption "swayidle";

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      systemdTarget = "wayland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "wayland-locker";
        }
        {
          event = "after-resume";
          # command = "wlopm --on *";
          command = "niri msg action power-on-monitors";
        }
      ];
      timeouts =
        [
          {
            timeout = 600;
            command = "wayland-locker";
          }
          {
            timeout = 900;
            # command = "wlopm --off *";
            command = "niri msg action power-off-monitors";
          }
        ]
        ++ lib.optionals (!config.dotfiles.gui.dontSleep) [
          {
            timeout = 360;
            command = "systemctl sleep";
          }
        ];
    };

    systemd.user.services.swayidle.Service.Environment = lib.mkForce [
      "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
    ];
  };
}
