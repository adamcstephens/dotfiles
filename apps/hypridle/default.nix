{
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.hypridle;
in
{
  options.dotfiles.apps.hypridle = {
    enable = lib.mkEnableOption "hypridle service";
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "wayland-monitor on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = "wayland-locker";
        };

        listener =
          [
            {
              timeout = 60;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 60;
              on-timeout = "brightnessctl -sd tpacpi::kbd_backlight set 1";
              on-resume = "brightnessctl -sd tpacpi::kbd_backlight set 2";
            }
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 900;
              on-timeout = "wayland-monitor off";
              on-resume = "wayland-monitor on";
            }
          ]
          ++ lib.optionals (!config.dotfiles.gui.dontSleep) [
            {
              timeout = 360;
              on-timeout = "systemctl sleep";
            }
          ];
      };
    };

    systemd.user.services.hypridle.Service.Environment = [
      "PATH=${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin"
    ];
  };
}
