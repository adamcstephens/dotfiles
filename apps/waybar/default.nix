{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gui.wayland {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "wayland-session.target";
      package = pkgs.waybar.override {
        swaySupport = false;
        hyprlandSupport = false;
      };

      settings.main = import ./settings.nix { inherit lib; };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "${config.dotfiles.gui.font.variable}", "Symbols Nerd Font Mono";
          font-size: 14px;
          box-shadow: none;
          text-shadow: none;
          transition-duration: 0s;
        }

        window#waybar {
          color: #${config.colorScheme.colors.base0B};
          background-color: #${config.colorScheme.colors.base00};
          border-bottom: 2px solid #${config.colorScheme.colors.base03};
        }

        window#waybar.solo {
          color: #${config.colorScheme.colors.base0B};
        }

        #tags {
        }

        #tags button {
          color: #${config.colorScheme.colors.base03};
          min-width: 14px;
        }

        #tags button.occupied {
          color: #${config.colorScheme.colors.base04};
        }

        #tags button.focused {
          color: #${config.colorScheme.colors.base09};
        }

        #tags button.urgent {
          color: #${config.colorScheme.colors.base08};
        }

        #battery,
        #clock,
        #idle_inhibitor,
        #network,
        #pulseaudio,
        #bluetooth,
        #tray {
          margin: 0px 10px;
          min-width: 10px;
          color: #${config.colorScheme.colors.base04};
        }

        #battery.warning {
          color: #${config.colorScheme.colors.base0A};
        }

        #battery.critical {
          color: #${config.colorScheme.colors.base08};
        }

        #battery.charging {
          color: #${config.colorScheme.colors.base0D};
        }

        #battery.plugged {
          color: #${config.colorScheme.colors.base0B};
        }
      '';
    };

    systemd.user.services.waybar.Unit = {
      Environment = [ "FONTCONFIG_FILE=${config.dotfiles.gui.font.fontconfig}" ];
      PartOf = lib.mkForce [ "wayland-session.target" ];
      After = lib.mkForce [ "wayland-session.target" ];
    };
  };
}
