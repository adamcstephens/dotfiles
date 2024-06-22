{
  config,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [
    config.programs.rofi.package

    pkgs.brightnessctl
    pkgs.gtk3 # for gtk-launch
    pkgs.playerctl
    pkgs.river-bnf
    pkgs.wl-mirror # and wl-present
  ];
in
{
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
        riverctl background-color 0x${config.colorScheme.palette.base00}
        riverctl border-color-focused 0x${config.colorScheme.palette.base05}
        riverctl border-color-unfocused 0x${config.colorScheme.palette.base03}
      '';

      onChange = ''
        ~/.config/river/colors.sh
      '';
    };

    xdg.configFile."river/start" = {
      text = ''
        #!${lib.getExe pkgs.bash}

        if ! command -v river &>/dev/null; then
          echo "!! No river binary found in path"
          exit 1
        fi

        # cleanup any xserver
        systemctl --user stop xserver-session.target
        systemctl --user unset-environment DISPLAY

        # start wayland session
        . "$HOME"/.nix-profile/bin/configure-gtk

        export MOZ_ENABLE_WAYLAND="1"
        export NIXOS_OZONE_WL="1"
        export PATH=$HOME/.dotfiles/bin:${lib.makeBinPath dependencies}:$PATH

        # gnome-keyring unlock needs this
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"

        export XDG_CURRENT_DESKTOP=river
        systemctl --user import-environment XDG_CURRENT_DESKTOP

        systemd-cat --identifier=river river

        systemctl --user stop wayland-session.target graphical-session.target
      '';

      executable = true;
    };
  };
}
