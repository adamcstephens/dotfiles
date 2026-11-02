{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.atuin.overrideAttrs {
    doCheck = false;
  };
in
{
  config = lib.mkMerge [
    {
      home.packages = [ package ];

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
            ExecStart = "${lib.getExe package} daemon start";
            Restart = "on-abort";
          };
        };
      };
    })
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      launchd.agents.atuin = {
        enable = true;
        config = {
          KeepAlive = true;
          Program =
            pkgs.writeShellApplication {
              name = "atuin-daemon";
              runtimeInputs = [ package ];
              text = ''
                # force clean atuin socket in case of crash https://github.com/atuinsh/atuin/issues/2289
                rm -f ${lib.escapeShellArg "${config.home.homeDirectory}/.local/share/atuin/atuin.sock"}

                exec atuin daemon
              '';
            }
            |> lib.getExe;
          RunAtLoad = true;
        };
      };
    })
  ];
}
