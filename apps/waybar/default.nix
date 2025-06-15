{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.waybar;
in
{
  options.dotfiles.apps.waybar = {
    enable = lib.mkEnableOption "waybar service";

    battery = lib.mkOption {
      type = lib.types.enum [
        "battery"
        "upower"
      ];
      default = "battery";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "wayland-session.target";

      settings.main = import ./settings.nix {
        inherit lib;
        inherit (cfg) battery;
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "${config.dotfiles.gui.font.variable}";
          font-size: 14px;
          box-shadow: none;
          text-shadow: none;
          transition-duration: 0s;
        }

        window#waybar {
          color: #${config.colorScheme.palette.base0B};
          background-color: #${config.colorScheme.palette.base00};
          border-bottom: 2px solid #${config.colorScheme.palette.base03};
        }

        window#waybar.solo {
          color: #${config.colorScheme.palette.base0B};
        }

        #tags {
        }

        #workspaces button.empty,
        #tags button {
          color: #${config.colorScheme.palette.base02};
          min-width: 14px;
        }

        #workspaces button,
        #tags button.occupied {
          color: #${config.colorScheme.palette.base04};
        }

        #workspaces button.visible,
        #workspaces button.active,
        #tags button.focused {
          color: #${config.colorScheme.palette.base06};
          background-color: #${config.colorScheme.palette.base03};
        }

        #workspaces button.urgent,
        #tags button.urgent {
          color: #${config.colorScheme.palette.base08};
        }

        #battery,
        #clock,
        #idle_inhibitor,
        #network,
        #pulseaudio,
        #bluetooth,
        #tray,
        #upower {
          margin: 0px 10px;
          min-width: 10px;
          color: #${config.colorScheme.palette.base04};
        }

        #battery.warning {
          color: #${config.colorScheme.palette.base0A};
        }

        #battery.critical {
          color: #${config.colorScheme.palette.base08};
        }

        #battery.charging {
          color: #${config.colorScheme.palette.base0D};
        }

        #battery.plugged {
          color: #${config.colorScheme.palette.base0B};
        }

        #upower.charging {
          color: #${config.colorScheme.palette.base0D};
        }

        #upower.discharging {
          color: #${config.colorScheme.palette.base0A};
        }
      '';
    };

    systemd.user.services.waybar = {
      Service.Environment = lib.mkForce "PATH=${
        lib.makeBinPath [
          pkgs.blueberry
          pkgs.networkmanagerapplet
          pkgs.pwvucontrol
        ]
      }";
      Unit = {
        PartOf = lib.mkForce [ "wayland-session.target" ];
        After = lib.mkForce [
          "wayland-session.target"
          "xdg-desktop-portal.service"
        ];
      };
    };
  };
}
