{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  colors = config.colorScheme.palette;
  locker = pkgs.writeShellScriptBin "locker" ''
    export PATH=$PATH:${
      lib.makeBinPath [
        pkgs.gtklock
        pkgs.waylock
      ]
    }

    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
      pidof gtklock || exec gtklock
    else
      pidof waylock || exec waylock -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}
    fi
  '';
in
{
  imports = [ inputs.sandbox.homeModules.sleepwatcher-rs ];

  services.sleepwatcher-rs = {
    enable = true;

    configFile =
      if config.dotfiles.nixosManaged then
        ./idle_config.lua
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/sleepwatcher-rs/idle_config.lua";

    dependencies = [
      locker
      pkgs.playerctl
      pkgs.wlopm
    ];

    systemdTarget = "wayland-session.target";
  };

  # systemd.user.services.sleepwatcher-rs.Service.Environment = [ "RUST_LOG=debug" ];
}
