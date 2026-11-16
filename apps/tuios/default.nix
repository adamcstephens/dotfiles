{
  config,
  dotlib,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.tuios;
  package = inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios;
in
{
  options.dotfiles.apps.tuios.package = (lib.mkPackageOption pkgs "tuios" { }) // {
    default = package;
  };

  config = lib.mkMerge [
    {
      home.packages = [ cfg.package ];

      xdg.configFile."tuios/config.toml".source = dotlib.source "apps/tuios/config.toml";
      xdg.configFile."tuios/themes".source = dotlib.source "apps/tuios/themes";
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user = {
        services.tuios = {
          Install.WantedBy = [ "default.target" ];
          Unit.X-SwitchMethod = "reload";

          Service = {
            Type = "simple";
            ExecStartPre = "${lib.getExe cfg.package} kill-server";
            ExecStart = "${lib.getExe cfg.package} daemon";
            ExecReload = "${lib.getExe cfg.package} daemon upgrade";
            Restart = "on-failure";
          };
        };
      };
    })
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      launchd.agents.tuios = {
        enable = true;
        config = {
          EnvironmentVariables.XDG_CONFIG_HOME = config.xdg.configHome;
          ProgramArguments = [
            (lib.getExe cfg.package)
            "daemon"
          ];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
        };
      };
    })
  ];
}
