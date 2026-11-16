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
        sockets.tuios = {
          Install.WantedBy = [ "default.target" ];
          Socket = {
            ListenStream = "%t/tuios/tuios.sock";
            Accept = false;
            SocketMode = "0600";
          };
        };

        services.tuios = {
          Install.WantedBy = [ "default.target" ];

          Service = {
            Type = "simple";
            ExecStartPre = "${lib.getExe cfg.package} kill-server";
            ExecStart = "${lib.getExe cfg.package} daemon";
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
