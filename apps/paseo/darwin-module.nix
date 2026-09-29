{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paseo;
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;

  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "paseo-config.json" cfg.settings;

  start = pkgs.writeShellScript "paseo-start" ''
    /bin/mkdir -p ${lib.escapeShellArg cfg.dataDir}
    ${lib.optionalString (cfg.settings != { }) ''
      /usr/bin/install -m 0600 ${settingsFile} ${lib.escapeShellArg "${cfg.dataDir}/config.json"}
    ''}
    exec ${lib.getExe' cfg.package "paseo-server"} ${
      lib.optionalString (!cfg.relay.enable) "--no-relay"
    }
  '';
in
{
  options.services.paseo = {
    enable = lib.mkEnableOption "paseo service for user";

    package = lib.mkPackageOption pkgs "paseo" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "where to store paseo data";
      default = "${home}/.local/state/paseo";
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

    relay = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable relay-based remote access. When false, the daemon
          runs with `--no-relay` and only accepts direct (LAN/loopback)
          connections.
        '';
      };

      mode = lib.mkOption {
        type = lib.types.enum [
          "hosted"
          "remote"
        ];
        default = "hosted";
        description = ''
          How the daemon reaches the relay when `relay.enable = true`:

          - `"hosted"` (default): use the upstream `app.paseo.sh` relay.
            Preserves the current behavior; no extra options needed.
          - `"remote"`: connect to a self-hosted relay at
            `relay.host:relay.port`. Sets `PASEO_RELAY_ENDPOINT` and
            `PASEO_RELAY_USE_TLS` for the daemon.

          A `"local"` mode (running a relay on the same host as a launchd
          agent) is not yet implemented — the relay package currently only
          ships a Cloudflare Workers adapter. Tracked separately.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "relay.example.com";
        description = "Relay hostname. Required when `relay.mode = \"remote\"`.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 443;
        description = "Relay port. Used when `relay.mode = \"remote\"`.";
      };

      useTls = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to use TLS when connecting to the relay. Used when `relay.mode = \"remote\"`.";
      };

      publicUseTls = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Whether the public (client-facing) relay endpoint uses TLS.
          When `null` (default), the daemon falls back to `relay.useTls`.
          Override when the internal path is plain `ws://` behind a
          TLS-terminating reverse proxy.
        '';
      };
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          PASEO_RELAY_ENDPOINT = "relay.paseo.sh:443";
        }
      '';
      description = "Extra environment variables for the Paseo daemon.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        config = {
          version = 1;
        };
      };
      example = lib.literalExpression ''
        {
          daemon.mcp = { enabled = true; injectIntoAgents = false; };
          agents.providers.myAcp = {
            extends = "acp";
            label = "My Agent";
            command = { path = "/etc/profiles/per-user/adam/bin/my-acp"; };
          };
          log.file = { level = "info"; path = "/Users/adam/Library/Logs/paseo.log"; };
        }
      '';
      description = ''
        Declarative content for `$PASEO_HOME/config.json`. Rendered to JSON
        and installed on every service start.

        Runtime mutations to `config.json` (e.g. via `paseo daemon set-password`
        or the mobile app toggling MCP injection / provider overrides) are
        overwritten on the next restart. Pick one: manage via this option, or
        manage via the CLI — not both.

        The full schema is defined by `PersistedConfigSchema` in
        `packages/server/src/server/persisted-config.ts`.
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.user.agents.paseo.serviceConfig = {
      ProgramArguments = [ "${start}" ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      ThrottleInterval = 5;
      ExitTimeOut = 15;

      EnvironmentVariables = {
        PATH = lib.concatStringsSep ":" [
          "${home}/.local/state/hjem/standalone/current-profile/bin"
          "${home}/.nix-profile/bin"
          "${home}/.local/state/nix/profile/bin"
          "/etc/profiles/per-user/${user}/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
        PASEO_HOME = cfg.dataDir;
        PASEO_LISTEN = "${cfg.listenAddress}:${toString cfg.port}";
      }
      // lib.optionalAttrs (cfg.hostnames == true) {
        PASEO_HOSTNAMES = "true";
      }
      // lib.optionalAttrs (lib.isList cfg.hostnames && cfg.hostnames != [ ]) {
        PASEO_HOSTNAMES = lib.concatStringsSep "," cfg.hostnames;
      }
      // lib.optionalAttrs (cfg.relay.enable && cfg.relay.mode == "remote") {
        PASEO_RELAY_ENDPOINT = "${cfg.relay.host}:${toString cfg.relay.port}";
        PASEO_RELAY_USE_TLS = if cfg.relay.useTls then "true" else "false";
      }
      //
        lib.optionalAttrs (cfg.relay.enable && cfg.relay.mode == "remote" && cfg.relay.publicUseTls != null)
          {
            PASEO_RELAY_PUBLIC_USE_TLS = if cfg.relay.publicUseTls then "true" else "false";
          }
      // cfg.environment;
    };

    environment.systemPackages = [ cfg.package ];
  };
}
