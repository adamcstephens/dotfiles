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

      agents.providers = {
        claude.enabled = true;
        codex.enabled = true;
        copilot.enabled = false;
        opencode.enabled = false;
        omp.enabled = true;
        pi.enabled = false;
      };

      features = {
        dictation.enabled = false;
        voiceMode.enabled = false;
      };
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
