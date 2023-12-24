{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.river;

  dependencies = [
    config.programs.kitty.package
    config.programs.rofi.package

    pkgs.brightnessctl
    pkgs.gtk3 # for gtk-launch
    pkgs.playerctl
    pkgs.river-bnf
    pkgs.wl-mirror # and wl-present
  ];
in
{
  options = {
    dotfiles.apps.river.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.river;
    };
  };

  config = lib.mkIf config.dotfiles.gui.wayland {
    home.packages = [ cfg.package ];

    xdg.configFile."river/init" = {
      executable = true;
      source = ./init.sh;
    };

    xdg.configFile."river/colors.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # Set background and border color
        riverctl background-color 0x${config.colorScheme.colors.base00}
        riverctl border-color-focused 0x${config.colorScheme.colors.base05}
        riverctl border-color-unfocused 0x${config.colorScheme.colors.base03}
      '';

      onChange = ''
        ~/.config/river/colors.sh
      '';
    };

    xdg.configFile."river/start" = {
      text = ''
        export MOZ_ENABLE_WAYLAND="1"
        export NIXOS_OZONE_WL="1"
        export PATH=$HOME/.dotfiles/bin:${lib.makeBinPath dependencies}:$PATH

        systemd-cat --identifier=river ${lib.getExe cfg.package}

        systemctl --user stop wayland-session.target
      '';

      executable = true;
    };
  };
}
