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
in
{
  options.dotfiles.apps.tuios.package = (lib.mkPackageOption pkgs "tuios" { }) // {
    default = inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios;
    # inputs.nixpkgs-tuios.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios.overrideAttrs
    #   { doCheck = false; };
  };

  config = lib.mkMerge [
    {
      home.packages = [ cfg.package ];

      smfh.xdg.config.files."tuios/config.toml".source = dotlib.source "apps/tuios/config.toml";
      smfh.xdg.config.files."tuios/themes".source = dotlib.source "apps/tuios/themes";
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
