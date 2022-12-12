{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar.override {swaySupport = false;};

    settings = builtins.readFile ./waybar.jsonc;

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
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

      #workspaces {
        margin: 0 5px;
      }

      #tags button {
        color: #${config.colorScheme.colors.base03};
        padding: 0 7px;
      }

      #tags button.occupied,
      #workspaces button {
        padding: 0 7px;
        color: #${config.colorScheme.colors.base04};
      }

      #tags button.focused,
      #workspaces button.focused {
        color: #${config.colorScheme.colors.base09};
      }

      #workspaces button.visible {
        color: #${config.colorScheme.colors.base09};
      }

      #tags button.urgent,
      #workspaces button.urgent {
        color: #${config.colorScheme.colors.base08};
      }

      /* sway mode */
      #mode {
        color: #${config.colorScheme.colors.base0E};
        margin: 0px 6px 0px 10px;
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

    '';
  };
}
