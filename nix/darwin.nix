{
  inputs,
  withSystem,
  ...
}: {
  flake.darwinConfigurations.mac = withSystem "aarch64-darwin" ({system, ...}:
    inputs.darwin.lib.darwinSystem {
      inherit inputs system;

      modules = [
        {
          nixpkgs.overlays = [inputs.firefox-darwin.overlay];
          nix = {
            settings = {
              auto-optimise-store = true;

              trusted-users = ["root" "astephe9"];
              substituters = [
                "https://nix-config.cachix.org"
                "https://nix-community.cachix.org"
                "https://nix-serve.junco.dev"
              ];
              trusted-public-keys = [
                "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "nix-serve.junco.dev:wAHV4z39dUu7A6/PqOc9bqYxKUXqh2cogkav4+eJrkM="
              ];
            };
          };
          services.nix-daemon.enable = true;
        }
        ({pkgs, ...}: {
          system.defaults.NSGlobalDomain = {
            InitialKeyRepeat = 15;
            KeyRepeat = 1;

            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
          };
          system.defaults.dock = {
            autohide = true;
            autohide-delay = 2.0;
            orientation = "left";
            showhidden = true;
            show-recents = false;
          };
          system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

          security.pam.enableSudoTouchIdAuth = true;
          time.timeZone = "America/New_York";

          programs.fish.enable = true;

          environment.shells = [pkgs.fish];
          environment.systemPackages = [
          ];

          users.users.astephe9 = {
            shell = pkgs.fish;
          };
        })
      ];
    });
}
