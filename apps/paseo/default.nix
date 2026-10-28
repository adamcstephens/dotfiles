{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  package =
    inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paseo.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ./omp-custom-message-history.patch ];
        doCheck = false;
      });
in
{
  imports = [
    ./module.nix
  ];

  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    package.desktop
  ];

  services.paseo = {
    enable = true;
    inherit package;

    settings = {
      app.baseUrl = "https://paseo.junco.dev";

      agents = {
        providers = {
          antigravity.enabled = false;
          claude.enabled = true;
          codex.enabled = true;
          copilot.enabled = false;
          muse.enabled = false;
          omp.enabled = true;
          opencode.enabled = true;
          pi.enabled = false;
        };

        metadataGeneration.providers = [
          {
            provider = "omp";
            model = "openai-codex/gpt-6-luna";
          }
        ];
      };

      daemon = {
        relay = {
          enabled = true;
          endpoint = "paseo-relay.junco.dev:443";
          useTls = true;
        };

        mcp = {
          enabled = true;
          injectIntoAgents = true;
        };

        agentProfiles = [
          {
            id = "agent_profile_mv4lollr_mxy2urjv64m";
            name = "lightweight";
            provider = "omp";
            model = "openai-codex/gpt-6-luna";
            modeId = "full";
            thinkingOptionId = "medium";
            notes = "Use for lightweight work, rote refactors, simple tasks.";
          }
          {
            id = "agent_profile_mv4lpdj7_nspeck1ll2d";
            name = "general";
            icon = "hammer";
            provider = "omp";
            model = "openai-codex/gpt-6.1-sol";
            modeId = "full";
            thinkingOptionId = "low";
            notes = "Use for general coding implementation.";
          }
        ];
      };

      features = {
        dictation.enabled = false;
        voiceMode.enabled = false;
      };

      pluginsEnabled = true;
    };
  };

  systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    paseo.Service.EnvironmentFile = "${config.services.paseo.dataDir}/pass.env";

    paseo-pwgen = {
      Unit = {
        Before = [ "paseo.service" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
        RequiredBy = [ "paseo.service" ];
      };

      Service = {
        Environment = [
          "PASEO_HOME=${config.services.paseo.environment.PASEO_HOME or config.services.paseo.dataDir}"
        ];
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          pkgs.writeShellApplication {
            name = "paseo-pwgen";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.pwgen
            ];
            text = ''
              mkdir -p "$PASEO_HOME"
              if [ ! -e "$PASEO_HOME/pass.env" ]; then
                echo "PASEO_PASSWORD=$(pwgen -sc1 32)" > "$PASEO_HOME/pass.env"
              fi
            '';
          }
          |> lib.getExe;
      };
    };
  };
}
