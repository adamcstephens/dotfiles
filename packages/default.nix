{
  inputs,
  pkgs,
  homeConfigurations,
  ...
}:
rec {
  arkenfox = pkgs.callPackage ./arkenfox { };
  dotfiles = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.callPackage ./dotfiles.nix {
    ocamlPackages =
      if pkgs.stdenv.isLinux then
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.pkgsMusl.ocaml-ng.ocamlPackages_5_3
      else
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.ocaml-ng.ocamlPackages_5_3;
  };
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  prj = pkgs.callPackage ./prj.nix { };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix { };
  rofi-wrapper = pkgs.callPackage ./rofi-wrapper.nix { };
}
