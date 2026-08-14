{
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      packages = [ pkgs.atuin ];

      xdg.config.files."atuin/config.toml".text =
        builtins.readFile ./config.toml
        + ''

          [daemon]
          enabled = true
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          systemd_socket = true
        '';
    }
    (lib.optionalAttrs (lib.hasAttr "systemd" options) {
      systemd = {
        sockets.atuin = {
          wantedBy = [ "default.target" ];
          socketConfig = {
            ListenStream = "%t/atuin.sock";
            Accept = false;
            SocketMode = "0600";
          };
        };

        services.atuin = {
          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe pkgs.atuin} daemon start";
            Restart = "on-abort";
          };
        };
      };
    })
  ];
}
