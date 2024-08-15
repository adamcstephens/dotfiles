{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    home.packages = [
      pkgs.gtklock
      # pkgs.hyprlock
    ];

    systemd.user.targets.hyprland-session = {
      Unit = {
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [
          "graphical-session-pre.target"
          "wayland-session.target"
          "xserver-session.target"
        ];
        Conflicts = [
          "wayland-session.target"
          "xserver-session.target"
        ];

        Requires = [
          "dunst.service"
          "gammastep.service"
          "kanshi.service"
          "sleepwatcher-rs.service"
          "waybar.service"
          "wob.service"
          "wob.socket"
        ];
      };
    };

    xdg.configFile."hypr/hyprland.conf".source =
      if config.dotfiles.nixosManaged then
        ./hyprland.conf
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprland/hyprland.conf";

    xdg.configFile."hypr/colors.conf" = {
      executable = true;
      text = ''
        general {
          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = rgba(${config.colorScheme.palette.base05}ee)
          col.inactive_border = rgba(${config.colorScheme.palette.base03}aa)
        }

        misc {
          background_color = rgb(${config.colorScheme.palette.base00})
        }
      '';

      onChange = ''
        ~/.config/river/colors.sh
      '';
    };

    # xdg.configFile."hypr/hypridle.conf".source =
    #   if config.dotfiles.nixosManaged then
    #     ./hypridle.conf
    #   else
    #     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprland/hypridle.conf";

    # systemd.user.services.hypridle = {
    #   Service.ExecStart = lib.getExe pkgs.hypridle;
    # };

    # xdg.configFile."hypr/hyprlock.conf".source =
    #   if config.dotfiles.nixosManaged then
    #     ./hyprlock.conf
    #   else
    #     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprland/hyprlock.conf";
  };
}
