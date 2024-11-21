{
  pkgs,
  homeConfigurations,
  ...
}:
rec {
  arkenfox = pkgs.callPackage ./arkenfox { };
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  prj = pkgs.callPackage ./prj.nix { };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix { };
  rofi-wrapper = pkgs.callPackage ./rofi-wrapper.nix { };
}
