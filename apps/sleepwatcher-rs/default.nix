{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.sleepwatcher-rs;
in
{
  imports = [ inputs.sandbox.homeModules.sleepwatcher-rs ];

  options.dotfiles.apps.sleepwatcher-rs.enable = lib.mkEnableOption "sleepwatcher-rs";

  config = lib.mkIf cfg.enable {
    services.sleepwatcher-rs = {
      enable = true;

      configFile =
        if config.dotfiles.nixosManaged then
          ./idle_config.lua
        else
          "${config.home.homeDirectory}/.dotfiles/apps/sleepwatcher-rs/idle_config.lua";

      dependencies = [
        config.dotfiles.gui.wayland.locker
        pkgs.hyprland
        pkgs.playerctl
        pkgs.wlopm
      ];

      systemdTarget = "wayland-session.target";
    };

    systemd.user.services.sleepwatcher-rs.Service.Environment = [ "RUST_LOG=debug" ];
  };
}
