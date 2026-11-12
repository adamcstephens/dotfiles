{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.atuin;
  socketPath = "${config.home.homeDirectory}/.local/share/atuin/atuin.sock";
  settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile ./config.toml)) (
    if pkgs.stdenv.hostPlatform.isLinux then
      { daemon.systemd_socket = true; }
    else
      { daemon.socket_path = socketPath; }
  );
  configFile = (pkgs.formats.toml { }).generate "atuin-config.toml" settings;
in
{
  config = lib.mkMerge [
    {
      home.packages = [ package ];

      xdg.configFile."atuin/config.toml".source = configFile;
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
            ExecStart = "${lib.getExe package} daemon start";
            Restart = "on-abort";
          };
        };
      };
    })
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      launchd.agents.atuin = {
        enable = true;
        restartTriggers = [ configFile ];
        config = {
          KeepAlive = true;
          Program =
            pkgs.writeShellApplication {
              name = "atuin-daemon";
              runtimeInputs = [ package ];
              text = ''
                # force clean atuin socket in case of crash https://github.com/atuinsh/atuin/issues/2289
                rm -f ${lib.escapeShellArg socketPath}

                exec atuin daemon --show-logs
              '';
            }
            |> lib.getExe;
          RunAtLoad = true;
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/atuin-daemon.log";
        };
      };
    })
  ];
}
