{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.gui.wayland {
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
        export

        systemd-cat --identifier=river river

        systemctl --user stop wayland-session.target
      '';

      executable = true;
    };
  };
}
