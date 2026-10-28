{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paseo;

  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "paseo-config.json" cfg.settings;

  environment = {
    PASEO_HOME = cfg.dataDir;
    PASEO_LISTEN = "${cfg.listenAddress}:${toString cfg.port}";
  }
  // lib.optionalAttrs (cfg.hostnames == true) {
    PASEO_HOSTNAMES = "true";
  }
  // lib.optionalAttrs (lib.isList cfg.hostnames && cfg.hostnames != [ ]) {
    PASEO_HOSTNAMES = lib.concatStringsSep "," cfg.hostnames;
  };

  startPre = pkgs.writeShellApplication {
    name = "paseo-start-pre";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      mkdir --parents ${lib.escapeShellArg cfg.dataDir}
      ${lib.optionalString (cfg.settings != { }) ''
        install --mode 0600 ${settingsFile} ${lib.escapeShellArg "${cfg.dataDir}/config.json"}
      ''}
    '';
  };

  start = pkgs.writeShellScript "paseo-start" ''
    ${lib.getExe startPre}
    exec ${lib.getExe' cfg.package "paseo-server"}
  '';
in
{
  options = {
    services.paseo = {
      enable = lib.mkEnableOption "paseo service for user";

      package = lib.mkPackageOption pkgs "paseo" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        description = "where to store paseo data";
        default = "${config.home.homeDirectory}/.local/state/paseo";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address for the Paseo daemon to bind to.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6767;
        description = "Port for the Paseo daemon to listen on.";
      };

      hostnames = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.either (lib.types.enum [ true ]) (lib.types.listOf lib.types.str)
        );
        default = null;
        example = [
          ".example.com"
          "myhost.local"
        ];
        description = ''
          Hostnames the Paseo daemon accepts in the Host header (DNS rebinding protection).
          Localhost and IP addresses are always allowed by default.

          Use a leading dot to match a domain and all its subdomains
          (e.g. `".example.com"` matches `example.com` and `foo.example.com`).

          Set to `true` to allow any host (not recommended).
        '';
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra environment variables for the Paseo daemon.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule ({
          freeformType = settingsFormat.type;

          config = {
            version = 1;
          };
        });
        example = lib.literalExpression ''
          {
            daemon.relay = { enabled = true; endpoint = "relay.example.com:443"; useTls = true; };
            daemon.mcp = { enabled = true; injectIntoAgents = false; };
            agents.providers.myAcp = {
              extends = "acp";
              label = "My Agent";
              command = { path = "/run/current-system/sw/bin/my-acp"; };
            };
            log.file = { level = "info"; path = "/var/lib/paseo/daemon.log"; };
          }
        '';
        description = ''
          Declarative content for `$PASEO_HOME/config.json`. Rendered to JSON
          and installed on every service start.

          Runtime mutations to `config.json` (e.g. via `paseo daemon set-password`
          or the mobile app toggling MCP injection / provider overrides) are
          overwritten on the next restart. Pick one: manage via this option, or
          manage via the CLI — not both.

          The full schema is available at
          https://paseo.sh/schemas/paseo.config.v1.json.
        '';
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.paseo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      Unit = {
        Description = "Paseo - self-hosted daemon for AI coding agents";
        X-Restart-Triggers = [ settingsFile ];
      };
      Install.WantedBy = [ "default.target" ];

      Service = {
        Environment = lib.mapAttrsToList (name: value: "${name}=${value}") (
          environment
          // {
            LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
            TZDIR = "${pkgs.tzdata}/share/zoneinfo";
          }
          // cfg.environment
        );

        Type = "simple";

        ExecStartPre = lib.getExe startPre;

        ExecStart = "${cfg.package}/bin/paseo-server";

        Restart = "on-failure";
        RestartSec = 5;

        # Graceful shutdown (server handles SIGTERM with a 10s timeout)
        KillSignal = "SIGTERM";
        TimeoutStopSec = 15;
      };
    };

    launchd.agents.paseo = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      enable = true;
      restartTriggers = [ settingsFile ];
      config = {
        ProgramArguments = [ "${start}" ];
        RunAtLoad = true;
        KeepAlive.SuccessfulExit = false;
        ThrottleInterval = 5;
        ExitTimeOut = 15;
        EnvironmentVariables =
          environment
          // {
            PATH = lib.concatStringsSep ":" [
              "${config.home.profileDirectory}/bin"
              "/nix/var/nix/profiles/default/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ];
          }
          // cfg.environment;
      };
    };

    home.packages = [ cfg.package ];
  };
}
