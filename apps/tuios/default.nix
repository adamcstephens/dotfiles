{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      packages = [
        pkgs.tuios
      ];

      xdg.config.files."tuios/config.toml".source = config.dotfiles.source "apps/tuios/config.toml";
      xdg.config.files."tuios/themes".source = config.dotfiles.source "apps/tuios/themes";
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

          environment.TERM = "xterm-ghostty";

          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe pkgs.tuios} daemon";
            Restart = "on-failure";
          };
        };
      };
    })
  ];
}
