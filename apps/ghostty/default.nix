{
  config,
  lib,
  npins,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.ghostty
        pkgs.ghostty.shell_integration
      ];

      xdg.config.files."ghostty/config".text = ''
        font-family = "${config.dotfiles.gui.font.mono}"
        config-file = dotfiles.conf
      ''
      + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        config-file = linux.conf
      ''
      + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        config-file = mac.conf
      '';

      xdg.config.files."ghostty/dotfiles.conf".source =
        if config.dotfiles.nixosManaged then
          ./dotfiles.conf
        else
          "${config.directory}/.dotfiles/apps/ghostty/dotfiles.conf";

      xdg.config.files."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        source =
          if config.dotfiles.nixosManaged then
            ./linux.conf
          else
            "${config.directory}/.dotfiles/apps/ghostty/linux.conf";
      };

      xdg.config.files."ghostty/gtk-custom.css" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        source =
          if config.dotfiles.nixosManaged then
            ./gtk-custom.css
          else
            "${config.directory}/.dotfiles/apps/ghostty/gtk-custom.css";
      };

      xdg.config.files."ghostty/mac.conf" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        source =
          if config.dotfiles.nixosManaged then
            ./mac.conf
          else
            "${config.directory}/.dotfiles/apps/ghostty/mac.conf";
      };

      xdg.data.files."dbus-1/services/com.mitchellh.ghostty.service" =
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux
          {
            text = ''
              [D-BUS Service]
              Name=com.mitchellh.ghostty
              SystemdService=ghostty.service
              Exec=${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false
            '';
          };

      xdg.config.files."ghostty/themes/moonfly".source =
        npins.vim-moonfly-colors + "/extras/moonfly-ghostty.conf";
      xdg.config.files."ghostty/themes/Modus Operandi".source =
        npins."modus-themes.nvim" + "/extras/ghostty/modus_operandi";
    }
    (lib.optionalAttrs (lib.hasAttr "systemd" options) {
      systemd.services.ghostty = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        wantedBy = [ "graphical-session.target" ];
        after = [
          "graphical-session.target"
          "dbus.socket"
        ];
        requires = [ "dbus.socket" ];

        path = [
          "${config.directory}/.local/state/hjem/standalone/current-profile"
          "/run/wrappers"
          "/run/current-system/sw"
        ];

        serviceConfig = {
          Type = "notify-reload";
          ReloadSignal = "SIGUSR2";
          BusName = "com.mitchellh.ghostty";
          ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
        };
      };
    })
  ];
}
