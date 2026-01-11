{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.atuin ];

  xdg.configFile."atuin/config.toml".text =
    builtins.readFile ./config.toml
    + ''

      [daemon]
      enabled = true
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      systemd_socket = true
    '';

  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    agents.atuin =
      let
        program = pkgs.writeShellScriptBin "atuin-daemon" ''
          # force clean atuin socket in case of crash https://github.com/atuinsh/atuin/issues/2289
          rm -f ${config.home.homeDirectory}/.local/share/atuin/atuin.sock

          exec ${lib.getExe pkgs.atuin} daemon
        '';
      in
      {
        enable = true;
        config = {
          KeepAlive = true;
          Program = lib.getExe program;
          RunAtLoad = true;
        };
      };
  };

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
}
