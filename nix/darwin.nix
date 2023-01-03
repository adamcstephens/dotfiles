{
  inputs,
  withSystem,
  ...
}: {
  flake.darwinConfigurations.mac = withSystem "aarch64-darwin" ({
    pkgs,
    system,
    ...
  }:
    inputs.darwin.lib.darwinSystem {
      inherit inputs system;

      modules = [
        ({config, ...}: {
          environment.etc."ssh/sshd_config.d/200-nix.conf".text = ''
            PasswordAuthentication no
            AllowUsers astephe9@10.3.2.* astephe9@10.20.10.*
          '';
          environment.shells = [pkgs.fish];
          fonts = {
            fontDir.enable = true;
            fonts = [
              pkgs.etBook
              pkgs.fira
              pkgs.font-awesome
              pkgs.jetbrains-mono
              pkgs.manrope
              pkgs.material-icons
              pkgs.material-design-icons
              pkgs.norwester-font
              pkgs.noto-fonts
              pkgs.noto-fonts-cjk
              pkgs.noto-fonts-emoji
              pkgs.roboto
              pkgs.source-sans
              (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];})
            ];
          };

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
            extraOptions = ''
              extra-platforms = x86_64-darwin
            '';
          };

          programs.fish.enable = true;
          security.pam.enableSudoTouchIdAuth = true;
          services.nix-daemon.enable = true;

          system.defaults = {
            NSGlobalDomain = {
              InitialKeyRepeat = 15;
              KeyRepeat = 1;

              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticDashSubstitutionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
            };
            dock = {
              autohide = true;
              autohide-delay = 2.0;
              orientation = "left";
              showhidden = true;
              show-recents = false;
            };
            SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
          };

          time.timeZone = "America/New_York";

          users.users.astephe9 = {
            shell = pkgs.fish;
          };
        })
      ];
    });
}
