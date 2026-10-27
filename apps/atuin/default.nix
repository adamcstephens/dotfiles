{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      home.packages = [ pkgs.atuin ];

      xdg.configFile."atuin/config.toml".text =
        builtins.readFile ./config.toml
        + ''

          [daemon]
          enabled = true
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          systemd_socket = true
        '';
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user = {
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
            ExecStart = "${lib.getExe pkgs.atuin} daemon start";
            Restart = "on-abort";
          };
        };
      };
    })
  ];
}
