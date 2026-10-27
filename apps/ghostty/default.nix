{
  config,
  dotlib,
  lib,
  npins,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.ghostty
        pkgs.ghostty.shell_integration
      ];

      xdg.configFile."ghostty/config".text = ''
        font-family = "${config.dotfiles.gui.font.mono}"
        config-file = dotfiles.conf
      ''
      + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        config-file = linux.conf
      ''
      + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        config-file = mac.conf
      '';

      xdg.configFile."ghostty/dotfiles.conf".source = dotlib.source "apps/ghostty/dotfiles.conf";

      xdg.configFile."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        source = dotlib.source "apps/ghostty/linux.conf";
      };

      xdg.configFile."ghostty/gtk-custom.css" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        source = dotlib.source "apps/ghostty/gtk-custom.css";
      };

      xdg.configFile."ghostty/mac.conf" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        source = dotlib.source "apps/ghostty/mac.conf";
      };

      xdg.dataFile."dbus-1/services/com.mitchellh.ghostty.service" =
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux
          {
            text = ''
              [D-BUS Service]
              Name=com.mitchellh.ghostty
              SystemdService=ghostty.service
              Exec=${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false
            '';
          };

      xdg.configFile."ghostty/themes/moonfly".source =
        dotlib.source "themes/moonfly/extras/moonfly-ghostty.conf";
      xdg.configFile."ghostty/themes/Modus Operandi".source =
        npins."modus-themes.nvim" + "/extras/ghostty/modus_operandi";
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user.services.ghostty = {
        Install.WantedBy = [ "graphical-session.target" ];
        Unit.After = [
          "graphical-session.target"
          "dbus.socket"
        ];
        Unit.Requires = [ "dbus.socket" ];

        Service = {
          Type = "notify-reload";
          ReloadSignal = "SIGUSR2";
          BusName = "com.mitchellh.ghostty";
          ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
        };
      };
    })
  ];
}
