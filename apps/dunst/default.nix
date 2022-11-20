{config, ...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        font = "JetBrainsMono Nerd Font 11";
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "20x20";
        frame_color = "#${config.colorScheme.colors.base03}";
        separator_color = "frame";
      };

      urgency_low = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 10;
      };
      urgency_normal = {
        background = "#${config.colorScheme.colors.base00}";
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
      WantedBy = ["graphical-session.target"];
    };
  };
}
