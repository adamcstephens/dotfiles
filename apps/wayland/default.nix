{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.dotfiles.gui.wayland = {
    enable = lib.mkEnableOption "Enable wayland resources";
    locker = lib.mkOption {
      type = lib.types.package;
      description = "package for locking screen";
    };
  };

  config = lib.mkIf config.dotfiles.gui.wayland.enable {
    home.packages = [
      pkgs.grim
      pkgs.gtklock
      pkgs.lswt
      pkgs.procps
      pkgs.qt6.qtwayland
      pkgs.slurp
      pkgs.waylock
      pkgs.wayshot
      pkgs.wdisplays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wl-mirror
      pkgs.wlopm
      pkgs.wlr-randr
    ];

    xdg.configFile."uwsm/env.d/home-manager.sh".text = ''
      . ${lib.escapeShellArg "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"}
    '';
  };
}
