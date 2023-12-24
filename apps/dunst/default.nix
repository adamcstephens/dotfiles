{ config, lib, ... }:
{
  services.dunst = {
    enable = true;

    iconTheme = {
      inherit (config.gtk.iconTheme) name package;
    };

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        font = "${config.dotfiles.gui.font.variable} 11";
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "20x50";
        frame_color = "#${config.colorScheme.colors.base05}";
        frame_width = 1;
        separator_color = "frame";
      };

      urgency_low = {
        background = "#${config.colorScheme.colors.base02}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 10;
      };
      urgency_normal = {
        background = "#${config.colorScheme.colors.base02}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 10;
      };
      urgency_critical = {
        background = "#${config.colorScheme.colors.base08}";
        foreground = "#${config.colorScheme.colors.base00}";
        timeout = 0;
      };
    };
  };

  systemd.user.services.dunst = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service.Environment = lib.mkForce [ "FONTCONFIG_FILE=${config.dotfiles.gui.font.fontconfig}" ];
  };
}
