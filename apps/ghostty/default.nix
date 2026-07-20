{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      packages = lib.optionals pkgs.stdenv.isLinux [
        pkgs.ghostty
        pkgs.ghostty.shell_integration
      ];

      xdg.config.files."ghostty/config".text = ''
        font-family = "${config.dotfiles.gui.font.mono}"
        config-file = dotfiles.conf
      ''
      + lib.optionalString pkgs.stdenv.isLinux ''
        config-file = linux.conf
      ''
      + lib.optionalString pkgs.stdenv.isDarwin ''
        config-file = mac.conf
      '';

      xdg.config.files."ghostty/dotfiles.conf".source =
        if config.dotfiles.nixosManaged then
          ./dotfiles.conf
        else
          "${config.directory}/.dotfiles/apps/ghostty/dotfiles.conf";

      xdg.config.files."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.isLinux {
        source =
          if config.dotfiles.nixosManaged then
            ./linux.conf
          else
            "${config.directory}/.dotfiles/apps/ghostty/linux.conf";
      };

      xdg.config.files."ghostty/gtk-custom.css" = lib.mkIf pkgs.stdenv.isLinux {
        source =
          if config.dotfiles.nixosManaged then
            ./gtk-custom.css
          else
            "${config.directory}/.dotfiles/apps/ghostty/gtk-custom.css";
      };

      xdg.config.files."ghostty/mac.conf" = lib.mkIf pkgs.stdenv.isDarwin {
        source =
          if config.dotfiles.nixosManaged then
            ./mac.conf
          else
            "${config.directory}/.dotfiles/apps/ghostty/mac.conf";
      };

      xdg.data.files."dbus-1/services/com.mitchellh.ghostty.service" = lib.mkIf pkgs.stdenv.isLinux {
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
    (lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      systemd.user.services.ghostty = lib.mkIf pkgs.stdenv.isLinux {
        Unit = {
          Description = "Ghostty";
          After = [
            "graphical-session.target"
            "dbus.socket"
          ];
          Requires = [ "dbus.socket" ];
        };

        Service = {
          Type = "notify-reload";
          ReloadSignal = "SIGUSR2";
          BusName = "com.mitchellh.ghostty";
          ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    })
  ];
}
