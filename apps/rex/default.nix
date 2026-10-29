{
  config,
  dotlib,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.rex;
in
{
  imports = [
    inputs.rex.homeManagerModules.default
  ];

  options = {
    dotfiles.apps.rex = {
      server.enable = lib.mkOption {
        type = lib.types.bool;
        description = "rex server";
        default = pkgs.stdenv.hostPlatform.isLinux;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.server.enable {
      programs.rex = {
        enable = true;
        sshGuard = false;
      };

      services.rex = {
        enable = true;
        extraListen = [ "[::]:7297" ];
        allowAnonymous = true;
      };

      home.file = {
        ".ssh/conf.d/50-rex.conf".source =
          "${config.programs.rex.package}/share/rex/ssh_config.d/50-rex.conf";
      };
    })
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      xdg.configFile."rex/init.lua".source = dotlib.source "apps/rex/init.lua";
    })
  ];
}
