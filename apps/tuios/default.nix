{
  dotlib,
  inputs,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      packages = [
        inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tuios
      ];

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
            ExecStartPre = "${lib.getExe pkgs.tuios} kill-server";
            ExecStart = "${lib.getExe pkgs.tuios} daemon";
            Restart = "on-failure";
          };
        };
      };
    })
  ];
}
