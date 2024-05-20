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
    exec ${lib.getExe pkgs.waylock} -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}
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
}
