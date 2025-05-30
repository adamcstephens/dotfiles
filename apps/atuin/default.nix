{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.atuin = {
    enable = true;

    flags = [ "--disable-up-arrow" ];

    settings = {
      daemon = {
        enabled = true;
        systemd_socket = pkgs.stdenv.isLinux;
      };

      enter_accept = false;
      filter_mode = "directory";
      inline_height = 30;
      style = "compact";
      sync_address = "https://atuin.junco.dev";
      sync.records = true;
      update_check = false;
      local_timeout = 15;
    };
  };

  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    agents.atuin =
      let
        program = pkgs.writeShellScriptBin "atuin-daemon" ''
          # force clean atuin socket in case of crash https://github.com/atuinsh/atuin/issues/2289
          rm -f ${config.home.homeDirectory}/.local/share/atuin/atuin.sock

          exec ${lib.getExe config.programs.atuin.package} daemon
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
        ExecStart = "${lib.getExe config.programs.atuin.package} daemon";
        Restart = "on-abort";
      };
    };
  };
}
