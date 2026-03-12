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
          color: @theme_text_color;
          background-color: alpha(@theme_bg_color, 0.94);
          border-bottom: 1px solid @unfocused_borders;
        }

        window#waybar.solo {
          color: @theme_text_color;
        }

        #tags {
        }

        #workspaces button.empty,
        #tags button {
          color: alpha(@theme_text_color, 0.6);
          min-width: 14px;
          background-color: transparent;
        }

        #workspaces button,
        #tags button.occupied {
          color: @theme_text_color;
        }

        #workspaces button.visible,
        #workspaces button.active,
        #tags button.focused {
          color: @theme_selected_fg_color;
          background-color: @theme_selected_bg_color;
        }

        #workspaces button.urgent,
        #tags button.urgent {
          color: @error_color;
          background-color: alpha(@error_color, 0.14);
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
          color: @theme_text_color;
        }

        #battery.warning {
          color: @warning_color;
        }

        #battery.critical {
          color: @error_color;
        }

        #battery.charging {
          color: @success_color;
        }

        #battery.plugged {
          color: @success_color;
        }

        #upower.charging {
          color: @success_color;
        }

        #upower.discharging {
          color: @warning_color;
        }
      '';
    };

    systemd.user.services.waybar = {
      Service.Environment = lib.mkForce "PATH=${
        lib.makeBinPath [
          pkgs.blueman
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
