{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gui.wayland {
    home.packages = [ pkgs.river-bnf ];

    systemd.user.targets.river-session = {
      Unit = {
        BindsTo = [ "wayland-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];

        Conflicts = [ "xserver-session.target" ];

        Requires = [ "sleepwatcher-rs.service" ];
      };
    };

    xdg.configFile."river/init" = {
      executable = true;
      source = ./init.sh;
    };

    xdg.configFile."river/colors.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        if ! command -v riverctl &>/dev/null; then
          exit 0
        fi

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

        source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        export PATH=$PATH:$HOME/.dotfiles/bin

        if ! command -v river &>/dev/null; then
          echo "!! No river binary found in path"
          exit 1
        fi

        # cleanup any previous sessions
        systemctl --user stop wayland-session.target xserver-session.target

        systemd-cat --identifier=river river

        systemctl --user stop wayland-session.target
      '';

      executable = true;
    };
  };
}
