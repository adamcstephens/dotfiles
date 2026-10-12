{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./module.nix
  ];

  services.paseo = {
    enable = true;
    package =
      inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paseo.overrideAttrs
        (old: {
          patches = (old.patches or [ ]) ++ [ ./omp-custom-message-history.patch ];
          doCheck = false;
        });

    relay = {
      enable = true;
      mode = "remote";
      host = "paseo-relay.junco.dev";
      port = 443;
      useTls = true;
    };

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
          opencode.enabled = false;
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
        mcp.injectIntoAgents = true;

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

  systemd.services.paseo.serviceConfig.EnvironmentFile = "${config.services.paseo.dataDir}/pass.env";

  systemd.services.paseo-pwgen = {
    wantedBy = [ "default.target" ];
    requiredBy = [ "paseo.service" ];
    before = [ "paseo.service" ];

    environment = {
      inherit (config.systemd.services.paseo.environment) PASEO_HOME;
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        pkgs.writeShellApplication {
          name = "paseo-pwgen";
          runtimeInputs = [ pkgs.pwgen ];
          text = ''
            if [ ! -e "$PASEO_HOME/pass.env" ]; then
              echo "PASEO_PASSWORD=$(pwgen -sc1 32)" > "$PASEO_HOME/pass.env"
            fi
          '';
        }
        |> lib.getExe;
    };
  };
}
