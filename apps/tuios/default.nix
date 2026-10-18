{
  dotlib,
  inputs,
  lib,
  options,
  pkgs,
  ...
}:
let
  package = inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios;
in

{
  config = lib.mkMerge [
    {
      packages = [ package ];

      xdg.config.files."tuios/config.toml".source = dotlib.source "apps/tuios/config.toml";
      xdg.config.files."tuios/themes".source = dotlib.source "apps/tuios/themes";
    }
    (lib.optionalAttrs (lib.hasAttr "systemd" options) {
      systemd = {
        sockets.tuios = {
          wantedBy = [ "default.target" ];
          socketConfig = {
            ListenStream = "%t/tuios/tuios.sock";
            Accept = false;
            SocketMode = "0600";
          };
        };

        services.tuios = {
          wantedBy = [ "default.target" ];

          # we want the default system path
          enableDefaultPath = false;

          serviceConfig = {
            Type = "simple";
            ExecStartPre = "${lib.getExe package} kill-server";
            ExecStart = "${lib.getExe package} daemon";
            Restart = "on-failure";
          };
        };

        services.tuios-ssh-sock = {
          wantedBy = [ "tuios.service" ];
          requires = [ "tuios.service" ];
          after = [ "tuios.service" ];
          partOf = [ "tuios.service" ];
          startLimitIntervalSec = 60;
          startLimitBurst = 30;

          path = [
            package
            pkgs.gojq
            pkgs.coreutils
            pkgs.gnused
          ];

          serviceConfig = {
            ExecStart = "${pkgs.runtimeShell} ${dotlib.source "bin/tuios-ssh-sock.sh"}";
            Restart = "always";
            RestartSec = "1s";
          };
        };
      };
    })
  ];
}
