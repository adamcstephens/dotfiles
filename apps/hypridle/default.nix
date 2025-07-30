{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.hypridle;

  beforeSleep = pkgs.writeShellApplication {
    name = "hypridle-before-sleep";
    text = ''
      loginctl lock-session
      app2unit -- brightnessctl -sd tpacpi::kbd_backlight set 0
    '';
  };

  afterSleep = pkgs.writeShellApplication {
    name = "hypridle-after-sleep";
    text = ''
      app2unit -- wayland-monitor on
      app2unit -- brightnessctl -sd tpacpi::kbd_backlight set 2
    '';
  };
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
          after_sleep_cmd = lib.getExe afterSleep;
          before_sleep_cmd = lib.getExe beforeSleep;
          ignore_dbus_inhibit = false;
          lock_cmd = "app2unit -- wayland-locker";
        };

        listener = [
          {
            timeout = 60;
            on-timeout = "app2unit -- brightnessctl -s set 10";
            on-resume = "app2unit -- brightnessctl -r";
          }
          {
            timeout = 60;
            on-timeout = "app2unit -- brightnessctl -sd tpacpi::kbd_backlight set 1";
            on-resume = "app2unit -- brightnessctl -sd tpacpi::kbd_backlight set 2";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 900;
            on-timeout = "app2unit -- wayland-monitor off";
            on-resume = "app2unit -- wayland-monitor on";
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
