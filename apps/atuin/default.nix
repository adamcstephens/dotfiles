{
  config,
  lib,
  pkgs,
  ...
}:
let
  atuinSockDir = "${config.home.homeDirectory}/.local/share/atuin";
  atuinSock = "${atuinSockDir}/atuin.sock";
  unitConfig = {
    Description = "Atuin Magical Shell History Daemon";
    ConditionPathIsDirectory = atuinSockDir;
  };
in
{
  programs.atuin = {
    enable = true;
    package =
      if (lib.versionAtLeast pkgs.atuin.version "18.3.0") then
        pkgs.atuin
      else
        pkgs.atuin.overrideAttrs (old: {
          patches = [
            # https://github.com/Mic92/dotfiles/blob/main/home-manager/pkgs/atuin/0001-make-atuin-on-zfs-fast-again.patch
            (pkgs.fetchpatch {
              url = "https://github.com/Mic92/dotfiles/raw/c2f538934d67417941f83d8bb65b8263c43d32ca/home-manager/pkgs/atuin/0001-make-atuin-on-zfs-fast-again.patch";
              hash = "sha256-i0kBQPr/oubW3i/BaAXx2CQx2OMN+iIAIGhz60+Qft8=";
            })
          ];
        });

    flags = [ "--disable-up-arrow" ];

    settings = {
      daemon = {
        enabled = true;
        systemd_socket = true;
      };

      enter_accept = false;
      filter_mode = "directory";
      inline_height = 30;
      style = "compact";
      sync_address = "https://atuin.junco.dev";
      update_check = false;
      local_timeout = 15;
    };
  };

  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    agents.atuin = {
      enable = true;
      config = {
        KeepAlive = true;
        ProgramArguments = [
          "${lib.getExe config.programs.atuin.package}"
          "daemon"
        ];
        RunAtLoad = true;
      };
    };
  };

  systemd.user = lib.mkIf (lib.versionAtLeast pkgs.atuin.version "18.3.0") {
    sockets.atuin = {
      Unit = unitConfig;
      Install.WantedBy = [ "default.target" ];
      Socket = {
        ListenStream = "${config.home.homeDirectory}/.local/share/atuin/atuin.sock";
        Accept = false;
        SocketMode = "0600";
      };
    };

    services.atuin = {
      Unit = unitConfig;
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe config.programs.atuin.package} daemon";
        Restart = "on-abort";
      };
    };
  };
}
