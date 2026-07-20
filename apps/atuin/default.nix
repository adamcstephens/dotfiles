{
  config,
  lib,
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
        + lib.optionalString pkgs.stdenv.isLinux ''
          systemd_socket = true
        '';
    }
    (lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      systemd.user = lib.mkIf (lib.versionAtLeast pkgs.atuin.version "18.3.0") {
        sockets.atuin = {
          Install.WantedBy = [ "default.target" ];
          Socket = {
            ListenStream = "%t/atuin.sock";
            Accept = false;
            SocketMode = "0600";
          };
        };

        services.atuin = {
          Service = {
            Type = "simple";
            ExecStart = "${lib.getExe pkgs.atuin} daemon";
            Restart = "on-abort";
          };
        };
      };
    })
  ];
}
