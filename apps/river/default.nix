{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gui.wayland.enable {
    home.packages = [
      # https://github.com/NixOS/nixpkgs/pull/476066
      (pkgs.river-bnf.overrideAttrs { env.NIX_CFLAGS_COMPILE = "-std=gnu17"; })
    ];

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
      text =
        let
          drmDevices = lib.concatStringsSep ":" config.dotfiles.gui.drmDevices;
        in
        ''
          #!${lib.getExe pkgs.bash}

          ${lib.optionalString (config.dotfiles.gui.drmDevices != [ ]) "export WLR_DRM_DEVICES=${drmDevices}"}

          source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
          export PATH=$PATH:$HOME/.dotfiles/bin

          if ! command -v river &>/dev/null; then
            echo "!! No river binary found in path"
            exit 1
          fi

          river
        '';

      executable = true;
    };

    systemd.user.services.nm-applet = {
      Unit = {
        PartOf = [ "wayland-session.target" ];
      };

      Install.WantedBy = [ "wayland-session.target" ];

      Service = {
        ExecStart = lib.getExe pkgs.networkmanagerapplet;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

  };
}
