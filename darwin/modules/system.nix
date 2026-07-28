{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  environment.shells = [ config.programs.fish.package ];

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.font-awesome
    pkgs.ibm-plex
    pkgs.jetbrains-mono
    pkgs.material-icons
    pkgs.material-design-icons
    pkgs.nerd-fonts.symbols-only
  ];

  networking.computerName = "willow";
  programs.fish = {
    enable = true;
    package = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish;
  };

  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };

  system.activationScripts.extraActivation.text = ''
    echo "removing nix from default profile"

    if nix profile list --json --profile /nix/var/nix/profiles/default | ${lib.getExe pkgs.gojq} --raw-output --exit-status .elements.nix; then
      nix profile remove nix --profile /nix/var/nix/profiles/default
    fi
  '';

  system.stateVersion = 5;

  # disable in normal operation to avoid restarting things that break firefox profile windows in dock
  # system.defaults = {
  #   NSGlobalDomain = {
  #     AppleShowScrollBars = "Always";
  #     InitialKeyRepeat = 15;
  #     KeyRepeat = 1;
  #
  #     NSAutomaticCapitalizationEnabled = false;
  #     NSAutomaticDashSubstitutionEnabled = false;
  #     NSAutomaticPeriodSubstitutionEnabled = false;
  #     NSAutomaticQuoteSubstitutionEnabled = false;
  #     NSAutomaticSpellingCorrectionEnabled = false;
  #   };
  #   dock = {
  #     autohide = true;
  #     autohide-delay = 2.0;
  #     orientation = "left";
  #     showhidden = true;
  #     show-recents = false;
  #   };
  #   SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  # };

  time.timeZone = "America/New_York";
}
