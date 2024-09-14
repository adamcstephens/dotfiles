{ pkgs, homeConfigurations, ... }:
rec {
  arkenfox = pkgs.callPackage ./arkenfox { };
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix { };
}
