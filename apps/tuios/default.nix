{
  dotlib,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  package = inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios;
in

{
  config = lib.mkMerge [
    {
      home.packages = [ package ];

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
            ExecStartPre = "${lib.getExe package} kill-server";
            ExecStart = "${lib.getExe package} daemon";
            Restart = "on-failure";
          };
        };
      };
    })
  ];
}
