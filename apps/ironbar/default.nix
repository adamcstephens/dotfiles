{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.ironbar;
in
{
  options.dotfiles.apps.ironbar = {
    enable = lib.mkEnableOption "ironbar service";

    package = lib.mkPackageOption inputs.ironbar.packages.${pkgs.system} "ironbar" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg.configFile."ironbar/config.json".text = builtins.toJSON {
      start = [
        {
          type = "workspaces";
        }
      ];
      center = [
        {
          type = "music";
          format = "{title} - {artist}";
          player_type = "mpris";
          truncate = "end";
        }
      ];
      end = [
        {
          type = "tray";
          icon_size = 32;
          prefer_theme_icons = true;
        }
        {
          type = "volume";
          format = "{icon}";
          max_volume = 100;
        }
        {
          type = "upower";
          format = "{percentage}%";
          icon_size = 16;
          icons = {
            muted = "󰝟";
            volume_high = "󰕾";
            volume_low = "󰕿";
            volume_medium = "󰖀";
          };
        }
        {
          type = "clock";
          format = "%m/%d %H:%M";
        }
      ];
      height = 30;
      icon_theme = config.gtk.iconTheme.name;
      position = "top";
    };

    xdg.configFile."ironbar/colors.css".text = ''
      @define-color color_bg #${config.colorScheme.palette.base00};
      @define-color color_fg #bdbdbd;
      @define-color color_01 #${config.colorScheme.palette.base01};
      @define-color color_03 #${config.colorScheme.palette.base03};

    '';

    xdg.configFile."ironbar/style.css".source =
      if config.dotfiles.nixosManaged then
        ./style.css
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ironbar/style.css";

    systemd.user.services.ironbar = {
      Unit = {
        PartOf = [ "wayland-session.target" ];
      };

      Install.WantedBy = [ "wayland-session.target" ];

      Service = {
        Environment = [
          "IRONBAR_CONFIG=${config.xdg.configFile."ironbar/config.json".source}"
        ];
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
