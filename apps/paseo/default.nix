{ inputs, pkgs, ... }:
{
  imports = [
    ./module.nix
  ];

  services.paseo = {
    enable = true;
    package = inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paseo;

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
}
